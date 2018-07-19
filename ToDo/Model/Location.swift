//
//  Location.swift
//  ToDo
//
//  Created by Mike Gopsill on 06/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import Foundation
import CoreLocation

struct Location : Equatable {
    let name: String
    let coordinates : CLLocationCoordinate2D?
    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"
    var plistDict: NSDictionary {
        var dict = [String:AnyObject]()
        dict[nameKey] = name as AnyObject
        if let coordinate = coordinates {
            dict[latitudeKey] = coordinate.latitude as AnyObject
            dict[longitudeKey] = coordinate.longitude as AnyObject
        }
        return dict as NSDictionary
    }

    init(name: String, coordinates: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinates = coordinates
    }
    
    init?(dict: NSDictionary) {
        guard let name = dict[nameKey] as? String else { return nil }
        let coordinate: CLLocationCoordinate2D?
        if let latitude = dict[latitudeKey] as? Double, let longitude = dict[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            coordinate = nil
        }
        self.name = name
        self.coordinates = coordinate
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.coordinates?.latitude == rhs.coordinates?.latitude &&
            lhs.coordinates?.longitude == rhs.coordinates?.longitude &&
            lhs.name == rhs.name
    }
}


