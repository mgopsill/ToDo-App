//
//  ToDoItemTests,.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 06/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_ShouldSetTitle(){
        let item = ToDoItem(title: "Test Title")
        XCTAssertEqual(item.title, "Test Title", "Initialiser should set the item title")
    }
    
    func testInit_ShouldTakeTitleAndDescription(){
        _ = ToDoItem(title: "Test Title", itemDescription: "Test Description")
    }
    
    func testInit_ShouldSetTitleAndDescriptionAndTimestamp(){
        let item = ToDoItem(title: "Test Title", itemDescription: "Test Description", timeStamp: 0.0)
        XCTAssertEqual(item.timeStamp, 0.0, "Timestamp should be initialised as 0.0")
    }
    
    func testInit_ShouldSetTitleAndDescriptionAndTimestampAndLocation() {
        let location = Location(name: "Test name")
        let item = ToDoItem(title: "Test Title", itemDescription: "Test Description", timeStamp: 0.0, location: location)
        
        XCTAssertEqual(location, item.location, "Initializer should set the location")
    }
    
    func testWhenOneLocationIsNilAndTheOtherIsnt_ShouldNotBeEqual(){
        var firstItem = ToDoItem(title: "First item", itemDescription: "Descr", timeStamp: 0.0, location: nil)
        var secondItem = ToDoItem(title: "First item", itemDescription: "Descr", timeStamp: 0.0, location: Location(name: "Test"))
        XCTAssertNotEqual(firstItem, secondItem)
        firstItem = ToDoItem(title: "First title", itemDescription: "First description", timeStamp: 0.0, location: Location(name: "Home"))
        secondItem = ToDoItem(title: "First title", itemDescription: "First description", timeStamp: 0.0, location: nil)
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenOneTimeStampDiffers_ShouldNotBeEqual(){
        let firstItem = ToDoItem(title: "First", itemDescription: "Desc", timeStamp: 0.0)
        let secondItem = ToDoItem(title: "First", itemDescription: "Desc", timeStamp: 0.1)
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenOneDescriptionDiffers_ShouldNotBeEqual(){
        let firstItem = ToDoItem(title: "Title", itemDescription: "Description")
        let secondItem = ToDoItem(title: "Title", itemDescription: "Different Description")
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenOneTitleDiffers_ShouldNotBeEqual(){
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "SecondItem")
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "First")
        let dictionary = item.plistDict
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)
    }
    
    func test_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "The Title", itemDescription: "The Description", timeStamp: 1.0, location: location)
        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }
}
