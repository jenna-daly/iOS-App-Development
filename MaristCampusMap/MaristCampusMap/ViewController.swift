//
//  ViewController.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 9/22/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManagement : CLLocationManager = CLLocationManager()

    @IBOutlet var ViewHolder: UIView!
    @IBOutlet weak var MapArrow: UIImageView!
    @IBOutlet weak var Nav: UINavigationBar!
    @IBOutlet weak var SelectLocationBTN: UIBarButtonItem!
    @IBOutlet weak var AddLocationBTN: UIBarButtonItem!
    @IBOutlet weak var AddLocationView: UIView!
    @IBOutlet weak var LocationList: UIPickerView!
    @IBOutlet weak var WelcomeImage: UIImageView!
    @IBOutlet weak var EnterNewLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManagement.delegate = self
        locationManagement.requestWhenInUseAuthorization()
        locationManagement.startUpdatingLocation()
    }

    @IBAction func AddLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = false
        MapArrow.isHidden = true
        WelcomeImage.isHidden = true
    }
    
    @IBAction func SelectLocationPressed(_ sender: Any) {
        AddLocationView.isHidden = true
        MapArrow.isHidden = true
        LocationList.isHidden = false
        WelcomeImage.isHidden = true
    }
}

