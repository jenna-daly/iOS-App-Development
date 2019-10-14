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
    PickerOption(name: "Donnelly", lat: 41.721012, lng: -73.932929),
    PickerOption(name: "Dyson", lat: 41.723848, lng: -73.932919),
    PickerOption(name: "Fontaine", lat: 41.725345, lng: -73.933116),
    PickerOption(name: "Football Field", lat: 41.719984, lng: -73.933442),
    PickerOption(name: "Foy", lat: 41.724686, lng: -73.934311),
    PickerOption(name: "Hancock", lat: 41.722712, lng: -73.934392),
    PickerOption(name: "James A Cannavino Library", lat: 41.721674, lng: -73.934400),
    PickerOption(name: "John and Nancy O'Shea Hall", lat: 41.726517, lng: -73.934083),
    PickerOption(name: "Lavelle Hall", lat: 41.726928, lng: -73.933820),
    PickerOption(name: "Lowell Thomas", lat: 41.723197, lng: -73.932690),
    PickerOption(name: "Lower Fulton", lat: 41.722559, lng: -73.928966),
    PickerOption(name: "Lower New", lat: 41.722749, lng: -73.935233),
    PickerOption(name: "Lower West", lat: 41.720837, lng: -73.929686),
    PickerOption(name: "Marketplace", lat: 41.721598, lng: -73.926078),
    PickerOption(name: "McCormick Hall", lat: 41.726234, lng: -73.934025),
    PickerOption(name: "Middle Fulton", lat: 41.722295, lng: -73.926500),
    PickerOption(name: "Midrise", lat: 41.721405, lng: -73.935440),
    PickerOption(name: "Steel Plant", lat: 41.721471, lng: -73.930791),
    PickerOption(name: "Student Center", lat: 41.721424, lng: -73.935330),
    PickerOption(name: "Tom & Mary Ward Hall", lat: 41.726681, lng: -73.933113),
    PickerOption(name: "Upper Fulton", lat: 41.723122, lng: -73.926847),
    PickerOption(name: "Upper New", lat: 41.723634, lng: -73.934594),
    PickerOption(name: "Upper West", lat: 41.720959, lng: -73.926252)

    ]
    
}
