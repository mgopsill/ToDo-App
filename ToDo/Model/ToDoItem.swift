//
//  ToDoItem.swift
//  ToDo
//
//  Created by Mike Gopsill on 06/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import Foundation

struct ToDoItem : Equatable {
    let title: String
    let itemDescription: String?
    let timeStamp: Double?
    let location: Location?
    private let titleKey = "titleKey"
    private let itemDescriptionKey = "itemDescriptionKey"
    private let timestampKey = "timestampKey"
    private let locationKey = "locationKey"
    var plistDict: NSDictionary {
        var dict = [String:AnyObject]()
        dict[titleKey] = title as AnyObject
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription as AnyObject
        }
        if let timestamp = timeStamp {
            dict[timestampKey] = timestamp as AnyObject
        }
        if let location = location {
            let locationDict = location.plistDict
            dict[locationKey] = locationDict
        }
        return dict as NSDictionary
    }
    
    init(title: String, itemDescription: String? = nil, timeStamp: Double? = nil, location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timeStamp = timeStamp
        self.location = location
    }
    
    init?(dict: NSDictionary) {
        guard let title = dict[titleKey] as? String else { return nil }
        self.title = title
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timeStamp = dict[timestampKey] as? Double
        if let locationDict = dict[locationKey] as? NSDictionary {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }
    
    
    static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return
            lhs.location == rhs.location &&
            lhs.timeStamp == rhs.timeStamp &&
            lhs.itemDescription == rhs.itemDescription &&
            lhs.title == rhs.title
    }
}


