//
//  Constants.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 10/13/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import Foundation
import CoreLocation

struct PickerOption { //rename
    init(name : String, lat : Double, lng : Double, description : String) {
        self.name = name
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.description = description
    }
    
    /*private enum CodingKeys: String, CodingKey {
        case name
        case location
        case description
    }

    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        location = try values.decode(CLLocationCoordinate2D.self, forKey: .location)
        description = try values.decode(String.self, forKey: .description)
    }*/

    var name : String
    var location : CLLocationCoordinate2D
    var description : String
}
struct Constants { //rename
    static var pickerOptions = [
        PickerOption(name: "Allied Health", lat: 41.722018, lng: -73.930244, description: "Allied Health was completed in 2016. It is home to the Physician's Assistant program and the undergraduate Athletic Training and Medical Technology programs."),
        PickerOption(name: "Donnelly", lat: 41.721012, lng: -73.932929, description: "Donnelly Hall houses financial services, advising and academic services, registrar, accomadations and accessability, safety and security, and the help desk."),
        PickerOption(name: "Dyson", lat: 41.723848, lng: -73.932919, description: "Dyson Center is where the School of Management and School of Social & Behavioral Sciences reside."),
        PickerOption(name: "Fontaine", lat: 41.725345, lng: -73.933116, description: "Fontaine contains the School of Liberal Arts, as well as alumni relations, the center for civic engagement and leadership, and the Hudson River Valley institute."),
        PickerOption(name: "Football Field", lat: 41.719984, lng: -73.933442, description: "The football field is where many Marist sporting events take place."),
        PickerOption(name: "Foy", lat: 41.724686, lng: -73.934311, description: "Foy is a sophomore residence area. Houses have five rooms of doubles, two bathrooms, a full kitchen and a balcony. "),
        PickerOption(name: "Hancock", lat: 41.722712, lng: -73.934392, description: "Hancock is home to the School of Computer Science and Mathematics. Also there are the offices for study abroad and the investment center."),
        PickerOption(name: "James A Cannavino Library", lat: 41.721674, lng: -73.934400, description: "The library is a central location on campus with the center for career services."),
        PickerOption(name: "John and Nancy O'Shea Hall", lat: 41.726517, lng: -73.934083, description: "John and Nancy O'Shea Hall is a junior and senior residence area. It is an apartment style building with four single rooms, a kitchen, and a living room in each apartment."),
        PickerOption(name: "Lavelle Hall", lat: 41.726928, lng: -73.933820, description: "Lavelle Hall is a junior and senior residence area. It is an apartment style building with four single rooms, a kitchen, and a living room in each apartment."),
        PickerOption(name: "Lowell Thomas", lat: 41.723197, lng: -73.932690, description: "LT holds the School of Communication and the Arts and the School of Professional Programs, as well as the center for sports communication and the media center."),
        PickerOption(name: "Lower Fulton", lat: 41.722559, lng: -73.928966, description: "Lower Fulton is a junior and senior residence area. It contains town houses with eight single rooms, a kitchen, and a living room."),
        PickerOption(name: "Lower New", lat: 41.722749, lng: -73.935233, description: "Lower New is a sophomore residence area. It contains four double rooms, a kitchen, and a living room."),
        PickerOption(name: "Lower West", lat: 41.720837, lng: -73.929686, description: "Lower West is a sophomore residence area with four double rooms, a kitchen, and a living room."),
        PickerOption(name: "Marketplace", lat: 41.721598, lng: -73.926078, description: "Marketplace is located within the Upper West residence area and contains a gym and a Cabaret style place to order food or buy common household goods."),
        PickerOption(name: "McCormick Hall", lat: 41.726234, lng: -73.934025, description: "McCormick Hall is a junior and senior residence area. It is an apartment style building with four single rooms, a kitchen, and a living room in each apartment."),
        PickerOption(name: "Middle Fulton", lat: 41.722295, lng: -73.926500, description: "Middle Fulton is a junior and senior residence area. It contains town houses with eight single rooms, a kitchen, and living room."),
        PickerOption(name: "Midrise", lat: 41.721405, lng: -73.935440, description: "Midrise is a freshmen residence area. It contains four double rooms with a common area."),
        PickerOption(name: "Steel Plant", lat: 41.721471, lng: -73.930791, description: "Steel Plant is a new Marist addition completed in 2018 that houses the Fashion and Art departments."),
        PickerOption(name: "Student Center", lat: 41.721424, lng: -73.935330, description: "The Student Center contains many things like the bookstore, student activities, student government, the Music department, the Admission Visitor Center, Post Office, dining hall and more."),
        PickerOption(name: "Tom & Mary Ward Hall", lat: 41.726681, lng: -73.933113, description: "Tom & Mary Ward Hall is a junior and senior residence area. It is an apartment style building with four single rooms, a kitchen, and a living room in each apartment."),
        PickerOption(name: "Upper Fulton", lat: 41.723122, lng: -73.926847, description: "Upper Fulton is a junior residence area. It contains town houses with eight single rooms, a kitchen, a living room, and a washer dryer unit."),
        PickerOption(name: "Upper New", lat: 41.723634, lng: -73.934594, description: "Upper New is a sophomore residence area. It contains four double rooms, a kitchen, and a living room."),
        PickerOption(name: "Upper West", lat: 41.720959, lng: -73.926252, description: "Upper West is a sophomore residence area with four double rooms, a kitchen, and a living room.")

        ]
    
}
