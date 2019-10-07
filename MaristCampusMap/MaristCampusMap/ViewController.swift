//
//  ViewController.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 9/22/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    @IBOutlet weak var HomeBTN: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManagement.delegate = self
        locationManagement.requestWhenInUseAuthorization()
        locationManagement.startUpdatingLocation()
        
        guard let path = Bundle.main.path(forResource: "MaristLocations", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil{
            print("error")
        }
        else{
            if let content = data {
                do{
                    let myJSON = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if let locs = myJSON["Name"] as? NSDictionary{
                        print(locs)
                    }
                }
                catch{}
            }
            }
        }
        task.resume()
        
        /*do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
            guard let array = json as? [Any] else {return}
            
            for user in array {
                guard let userDict = user as? [String: Any] else {return}
                guard let userLoc = userDict["Name"] as? String else {return}
                guard let userLat = userDict["Lat"] as? Int else {return}
                guard let userLong = userDict["Long"] as? Int else {return}
                
                print(userLoc)
                print(userLat)
                print(userLong)
            }
        }
        catch {
            print("error")
        }*/
    }
    
    let userDict = ["Hancock", "Donnelly", "Lowell Thomas", "Dyson", "Fontaine"]
    func numberOfComponents(in LocationList : UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ LocationList : UIPickerView, titleForRow row : Int, forComponent component : Int) -> String? {
        return userDict[row]
    }
    
    func pickerView(_ LocationList : UIPickerView, numberOfRowsInComponent component : Int) -> Int {
        return userDict.count
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
    @IBAction func HomeButtonPressed(_ sender: Any) {
        AddLocationView.isHidden = true
        MapArrow.isHidden = true
        LocationList.isHidden = true
        WelcomeImage.isHidden = false
        
    }
}

