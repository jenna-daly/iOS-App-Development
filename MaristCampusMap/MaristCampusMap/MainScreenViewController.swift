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
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    //end
    
    //we retrieve our data from the Constants.swift file
    var pickerOptions : [PickerOption] {
        get {
            //let userdefaults = userdefaults.get ..
            //return constants.pickeroptions + userdefaults
            return Constants.pickerOptions
            //need to append user defaults
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
    }
    
    
    //add-- plus sign nav bar button
    @IBAction func AddLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = false
        MapArrow.isHidden = true
        ArrivedDisplay.isHidden = true
        textField.isHidden = true

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
        
    }
    
    //Add button from add location view, appends users current location and given name to list of locations
    @IBAction func AddBtn(_ sender: Any) {
        print(EnterNewLocation.text!)
        if let location = locationManagement.location?.coordinate {
            let tempLoc = PickerOption.init(name: EnterNewLocation.text!, lat: location.latitude, lng: location.longitude, description: DescriptionInput.text ?? "")
            
            Constants.pickerOptions.append(tempLoc)

             do {
                let defaults = UserDefaults.standard
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: tempLoc, requiringSecureCoding: false)
                defaults.set(encodedData, forKey: "userAddedLoc")
                defaults.synchronize()
             } catch {
                 print("Couldn't write file")
             }
                        
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
        return self.pickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerOptions[row].name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.pickerOptions[row].name)
        self.selectedLocation = self.pickerOptions[row]
    }
}


extension MainScreenViewController : CLLocationManagerDelegate {
    //get user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            
            self.lastLocation = location
            
            //show description of buildings you pass
            for nearLocation in self.pickerOptions {
                let _selectedLocation = CLLocation(latitude: nearLocation.location.latitude, longitude: nearLocation.location.longitude)
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
                let selectedLocation = CLLocation(latitude: selectedOption.location.latitude, longitude: selectedOption.location.longitude)
                
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
        if let _lastLocation = self.lastLocation, let selectedLocation = self.selectedPickerOption?.location {
            let _selectedLocation = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            let yourLocationBearing = getBearingBetweenTwoPoints1(point1: _lastLocation, point2: _selectedLocation)
            var recommendedHeading = yourLocationBearing - deg2rad(newHeading.trueHeading)
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
        self.selectedPickerOption = self.pickerOptions[row]
        
        //label background color because dark mode changes text to white
        self.SelectedLocationLabel.backgroundColor = UIColor.red
        
        self.SelectedLocationLabel.text = String("\(self.selectedPickerOption!.description)")
        self.DestinationLabel.text = String("Destination:  \(self.selectedPickerOption!.name)")
       
        self.textField.resignFirstResponder()
        //MapArrow.image = UIImage(named: "MapArrow")
        MapArrow.isHidden = false
        ArrivedDisplay.isHidden = true
    }
    func didTapCancel() {
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
 
