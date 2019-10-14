//
//  Constants.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 10/13/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import Foundation
import CoreLocation

struct PickerOption {
    init(name : String, lat : Double, lng : Double) {
        self.name = name
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    let name : String
    let location : CLLocationCoordinate2D
}
struct Constants {
    static let pickerOptions = [
    PickerOption(name: "Allied Health", lat: 41.722018, lng: -73.930244),
    PickerOption(name: "Donnelly", lat: 41.721012, lng: -73.932929)
    ]
    
}
