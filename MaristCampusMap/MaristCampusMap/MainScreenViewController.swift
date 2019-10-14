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
    
    let pickerView = ToolbarPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManagement.delegate = self
        locationManagement.requestWhenInUseAuthorization()
        locationManagement.startUpdatingLocation()
        
        
        self.textField.inputView = self.pickerView
        self.textField.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
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

    }
    
    @IBAction func SelectLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = true
        MapArrow.isHidden = true
        self.textField.becomeFirstResponder()
        self.SelectedLocationLabel.text = ""

    }
    @IBAction func HomeButtonPressed(_ sender: Any) {
        //add storyboard reference like we did in startscreen
        AddLocationView.isHidden = true
        MapArrow.isHidden = false
        //self.SelectedLocationLabel.text = self.selectedLocation!.name
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
        if let location = locations.last {
            //compare selected location to this location and get angle bearing for arrow
            //then update arrow orientation, compare to self.selected
            print(location)
        }
    }
}

extension MainScreenViewController : ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.SelectedLocationLabel.text = String("\(self.pickerOptions[row].location.latitude) \t \(self.pickerOptions[row].location.longitude)")
        //self.SelectedLocationLabel.text = self.pickerOptions[row].name
        self.textField.resignFirstResponder()
        MapArrow.isHidden = false
    }
    func didTapCancel() {
        self.SelectedLocationLabel.text = nil
        self.textField.resignFirstResponder()
    }
}
