//
//  ViewController.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 9/22/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class MainScreenViewController: UIViewController {
    
    //used to ask for location
    let locationManagement : CLLocationManager = CLLocationManager()

    @IBOutlet var ViewHolder: UIView!
    @IBOutlet weak var MapArrow: UIImageView!
    @IBOutlet weak var Nav: UINavigationBar!
    @IBOutlet weak var SelectLocationBTN: UIBarButtonItem!
    @IBOutlet weak var AddLocationBTN: UIBarButtonItem!
    @IBOutlet weak var AddLocationView: UIView!
    @IBOutlet weak var EnterNewLocation: UITextField!
    @IBOutlet weak var HomeBTN: UIBarButtonItem!
    @IBOutlet weak var SelectedLocationLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var ArrivedDisplay: UIImageView!
    @IBOutlet weak var openCamera: UIButton!
    @IBOutlet weak var DescriptionInput: UITextField!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    //testing camera
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    //end test
    
    //var so app doesn't crash when pressing the camera button again
    var cameraOpen = false
    
    //select location picker view code
    let pickerView = ToolbarPickerView()
    
    var selectedPickerOption: PickerOption? = nil
    
    //used to track user location
    var lastLocation: CLLocation? = nil
    
    //lock orientation code to come, does not work right now
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        self.modalPresentationStyle = .fullScreen
        
        //if user doesn't have any picker options, it means it's the first time they're loading the app and we have to load in our default picker options
        if(self.getPickerOptions().count == 0) {
            let encodedPickerOptions = try? JSONEncoder().encode(defaultPickerOptions)
            try! UserDefaults.standard.set(encodedPickerOptions, forKey: "pickerOptions")
        }
        
        self.pickerOptions = self.getPickerOptions()
        
        EnterNewLocation.delegate = self
        
        //additional code to ask for location
        locationManagement.delegate = self
        locationManagement.requestWhenInUseAuthorization()
        locationManagement.desiredAccuracy = kCLLocationAccuracyBest
        locationManagement.startUpdatingLocation()
        locationManagement.startUpdatingHeading()
        
        //more picker view code
        self.textField.inputView = self.pickerView
        self.textField.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        
        //gives our image anchor points before we rotate it
        MapArrow.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
    }
    
    //camera code to go here
    //start test code for camera
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    func setupDevice(){
        let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscovery.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        }
        catch{
            print("error")
        }
    }
    var cameraView: AVCaptureVideoPreviewLayer?
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.cameraView = cameraPreviewLayer
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    //end
    
    //we retrieve our data from the Constants.swift file
    var pickerOptions : [PickerOption] = []
    
    func getPickerOptions() -> Array<PickerOption> {
        // TODO pull data from user defaults and join it to the defaultPickerOptions
        //      to get the full list of picker options (built-in plus user-defined)
        //      Alternatively, don't pull from user defaults, just use user-defined list of
        //      picker options if you have it as a variable somewhere
        //pulls data from user defaults as JSON and decodes it into picker option objects
        var pickerOptions: [PickerOption] = []
        if let data = UserDefaults.standard.value(forKey: "pickerOptions") as? Data {
            pickerOptions = (try? JSONDecoder().decode([PickerOption].self, from: data)) ?? []
        }
        return pickerOptions
    }
    func addNewPickerOptions(newValue: PickerOption) {
        // TODO add newValue to a separate list of user-defined PickerOptions
        // TODO store to UserDefaults only the user-define picker options
        //creates new copy of immutable picker options array
        var newPickerOptions = self.getPickerOptions().map{$0}
        newPickerOptions.append(newValue)
        //takes our picker option array and turns it into JSON data to save to user defaults
        if let encodedPickerOptions = try? JSONEncoder().encode(newPickerOptions) {
            UserDefaults.standard.set(encodedPickerOptions, forKey: "pickerOptions")
        }
    }
    //var can be changed, let cannot
    var selectedLocation : PickerOption? = nil
    
    
    @IBAction func openCameraPressed(_ sender: Any) {
        textField.isHidden = true
        if(cameraOpen == false) {
            //start
            setupCaptureSession()
            setupDevice()
            setupInputOutput()
            setupPreviewLayer()
            startRunningCaptureSession()
            cameraOpen = true
            //end
        }
        else if(cameraOpen == true) {
            self.cameraView?.removeFromSuperlayer()
            captureSession.stopRunning()
        }
    }
    
    
    //add-- plus sign nav bar button
    @IBAction func AddLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = false
        MapArrow.isHidden = true
        ArrivedDisplay.isHidden = true
        textField.isHidden = true
        self.textField.resignFirstResponder()

    }
    
    //select location nav bar button
    @IBAction func SelectLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = true
        MapArrow.isHidden = true
        ArrivedDisplay.isHidden = true
        textField.isHidden = false
        self.SelectedLocationLabel.text = ""
        self.textField.becomeFirstResponder()
    }
    
    //home nav bar button
    @IBAction func HomeButtonPressed(_ sender: Any) {
        //add storyboard reference like we did in startscreen
        AddLocationView.isHidden = true
        MapArrow.image = UIImage(named: "MapArrow")
        MapArrow.isHidden = false
        ArrivedDisplay.isHidden = true
        textField.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    //Add button from add location view, appends users current location and given name to list of locations
    @IBAction func AddBtn(_ sender: Any) {
        print(EnterNewLocation.text!)
        if let location = locationManagement.location?.coordinate {
            let tempLoc = PickerOption.init(name: EnterNewLocation.text!, lat: location.latitude, lng: location.longitude, description: DescriptionInput.text ?? "")
            
            //add a new option to user defaults and update our picker options array
            self.addNewPickerOptions(newValue: tempLoc)
            self.pickerOptions = self.getPickerOptions()
//            Constants.pickerOptions.append(tempLoc)
                        
            EnterNewLocation.text = ""
            DescriptionInput.text = ""
            
            let alert = UIAlertController(title: "Yay!", message: "You have successfully added a new location. You can now select it from the drop down or add more.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
                        
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "There was an error getting your location. Please make sure location services are enabled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //formulas
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    func rad2deg(_ number: Double) -> Double {
        return number * 180.0 / .pi
    }
    
    //distance formula
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {

        let lat1 = deg2rad(point1.coordinate.latitude)
        let lon1 = deg2rad(point1.coordinate.longitude)

        let lat2 = deg2rad(point2.coordinate.latitude)
        let lon2 = deg2rad(point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansBearing
    }

    
}

// MARK: - Extensions

//picker view code
extension MainScreenViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row].name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerOptions[row].name)
        selectedLocation = pickerOptions[row]
    }
}


extension MainScreenViewController : CLLocationManagerDelegate {
    //get user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            
            self.lastLocation = location
            
            //show description of buildings you pass
            for nearLocation in pickerOptions {
                let _selectedLocation = CLLocation(latitude: nearLocation.latitude, longitude: nearLocation.longitude)
                print(nearLocation.name)
                print(_selectedLocation)
                let distanceInMeters = location.distance(from: _selectedLocation)
                print(distanceInMeters)
                if(distanceInMeters < 20.0) {
                    SelectedLocationLabel.text = String("You are passing: \(nearLocation.name)\n\(nearLocation.description)")
                }
                
            }
            
            //alerts user they have reached their destination
            if let selectedOption = self.selectedPickerOption {
                let selectedLocation = CLLocation(latitude: selectedOption.latitude, longitude: selectedOption.longitude)
                
                let distanceInMeters = location.distance(from: selectedLocation)
                print(distanceInMeters)
                if(distanceInMeters < 20.0) {
                    ArrivedDisplay.isHidden = false
                    //MapArrow.image = UIImage(named: "ArrivedDisplay")
                    MapArrow.isHidden = true
                }
            }
        }
    }
    //get selected location coordinates, do the math between that and where the user is, take into account the heading or direction of the iPhone, rotate the arrow accordingly
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if let _lastLocation = self.lastLocation, let selectedLatitude = self.selectedPickerOption?.latitude, let selectedLongitude = self.selectedPickerOption?.longitude {
            let _selectedLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
            let yourLocationBearing = getBearingBetweenTwoPoints1(point1: _lastLocation, point2: _selectedLocation)
            var recommendedHeading = yourLocationBearing - deg2rad(newHeading.trueHeading)
            //bearingLabel.text = String("\(newHeading.trueHeading)")
            bearingLabel.text =  String("Accuracy: \(newHeading.headingAccuracy)")
            if (UIDevice.current.orientation == .faceDown) {
                recommendedHeading = -recommendedHeading
            }
            UIView.animate(withDuration: 0.5) {
                self.MapArrow.transform = CGAffineTransform(rotationAngle: CGFloat(recommendedHeading))
            }
        }
    }
}

//more picker view code for done and cancel buttons
extension MainScreenViewController : ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.selectedPickerOption = pickerOptions[row]
        
        //label background color because dark mode changes text to white
        self.SelectedLocationLabel.backgroundColor = UIColor.red
        
        self.SelectedLocationLabel.text = String("\(self.selectedPickerOption!.description)")
        self.DestinationLabel.text = String("Destination:  \(self.selectedPickerOption!.name)")
       
        self.textField.resignFirstResponder()
        //MapArrow.image = UIImage(named: "MapArrow")
        MapArrow.isHidden = false
        ArrivedDisplay.isHidden = true
        textField.isHidden = true
    }
    func didTapCancel() {
        textField.isHidden = true
        self.SelectedLocationLabel.text = nil
        self.textField.resignFirstResponder()
    }
}

extension MainScreenViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
 
