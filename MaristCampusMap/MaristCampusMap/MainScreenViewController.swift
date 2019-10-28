//
//  ViewController.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 9/22/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import UIKit
import CoreLocation

class MainScreenViewController: UIViewController {
    
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
    
    let pickerView = ToolbarPickerView()
    
    var selectedPickerOption: PickerOption? = nil
    
    var lastLocation: CLLocation? = nil
    
    //lock orientation code to come
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        EnterNewLocation.delegate = self
        
        locationManagement.delegate = self
        locationManagement.requestWhenInUseAuthorization()
        locationManagement.desiredAccuracy = kCLLocationAccuracyBest
        locationManagement.startUpdatingLocation()
        locationManagement.startUpdatingHeading()
        
        self.textField.inputView = self.pickerView
        self.textField.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        
        MapArrow.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.SelectedLocationLabel.backgroundColor = UIColor.blue
    }
    //let cannot be reassigned
    var pickerOptions : [PickerOption] {
        get {
            //let userdefaults = userdefaults.get ..
            //return constants.pickeroptions + userdefaults
            return Constants.pickerOptions
            //need to append user defaults
        }
    }
    //var can be changed
    var selectedLocation : PickerOption? = nil
    
    //populate picker view w test
    //let userDict = ["Hancock", "Donnelly", "Lowell Thomas", "Dyson", "Fontaine"]

        
    /*func pickerView(_ LocationList : UIPickerView, titleForRow row : Int, forComponent component : Int) -> String? {
        return userDict[row]
    }
        
    func pickerView(_ LocationList : UIPickerView, numberOfRowsInComponent component : Int) -> Int {
        return userDict.count
    }*/
    
    //button press
    @IBAction func AddLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = false
        MapArrow.isHidden = true
        ArrivedDisplay.isHidden = true

    }
    
    @IBAction func SelectLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = true
        MapArrow.isHidden = true
        ArrivedDisplay.isHidden = true
        self.SelectedLocationLabel.text = ""
        self.textField.becomeFirstResponder()

    }
    @IBAction func HomeButtonPressed(_ sender: Any) {
        //add storyboard reference like we did in startscreen
        AddLocationView.isHidden = true
        MapArrow.isHidden = false
        ArrivedDisplay.isHidden = true
        //self.SelectedLocationLabel.text = self.selectedLocation!.name
    }
    
    @IBAction func AddBtn(_ sender: Any) {
        print(EnterNewLocation.text!)
        if let location = locationManagement.location?.coordinate {
            let tempLoc = PickerOption.init(name: EnterNewLocation.text!, lat: location.latitude, lng: location.longitude, description: "")
            
            Constants.pickerOptions.append(tempLoc)
            
            EnterNewLocation.text = ""

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
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    func rad2deg(_ number: Double) -> Double {
        return number * 180.0 / .pi
    }
    
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
        //self.SelectedLocationLabel.text = self.selectedLocation!.name
    }
}

extension MainScreenViewController : CLLocationManagerDelegate {
    //print current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        if let location = locations.last {
            
            self.lastLocation = location
            
            if let selectedLocation =
                self.selectedPickerOption?.location {
            let _selectedLocation = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            
            let distanceInMeters = location.distance(from: _selectedLocation)
            print(distanceInMeters)
                if(distanceInMeters < 20.0) {
                    //let alert = UIAlertController(title: "You are here!", message: "You have reached your destination.", preferredStyle: .alert)
                    //alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    //self.present(alert, animated: true, completion: nil)
                    ArrivedDisplay.isHidden = false
                    MapArrow.isHidden = true
                }
                
            }
           
            //print(location)
            //compare selected location to this location and get angle bearing for arrow
            //then update arrow orientation, compare to self.selected
            /*let _selectedLocation = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            //print(location)
            let bearingInRad = getBearingBetweenTwoPoints1(point1: location, point2: _selectedLocation)
            
            print(rad2deg(bearingInRad))
            //MapArrow.transform = CGAffineTransform(rotationAngle: CGFloat(bearingInRad))
            let latestBearing = CGFloat(bearingInRad)
            UIView.animate(withDuration: 0.5) {
            self.MapArrow.transform = CGAffineTransform(rotationAngle: latestBearing - latestHeading)
            }*/

        }
    }
    
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
            
            /*let distanceInMeters = _selectedLocation.distance(from: _lastLocation)
            print(distanceInMeters)*/
            
        }
    }
}

extension MainScreenViewController : ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.selectedPickerOption = self.pickerOptions[row]
        //self.pickerView.selectRow(row, inComponent: 0, animated: false)
        //self.SelectedLocationLabel.text = String("\(self.selectedPickerOption!.location.latitude) \t \(self.selectedPickerOption!.location.longitude)")
        self.SelectedLocationLabel.text = String("\(self.selectedPickerOption!.description)")
        //self.SelectedLocationLabel.text = self.pickerOptions[row].name
        self.textField.resignFirstResponder()
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
 
