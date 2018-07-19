//
//  LocationTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 06/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_ShouldSetName(){
        let location = Location(name: "Test Name")
        XCTAssertEqual(location.name, "Test Name", "Initialiser should set name")
    }
    
    func testInit_ShouldSetNameAndCoordinate(){
        let testCoordinate =  CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "", coordinates: testCoordinate)
        
        XCTAssertEqual(location.coordinates?.latitude, testCoordinate.latitude, "Iniatlizer should set latitude")
        XCTAssertEqual(location.coordinates?.longitude, testCoordinate.longitude, "Iniatlizer should set longitude")
    }
    
    func testEqualLocations_ShouldBeEqual(){
        let firstLocation = Location(name: "Home")
        let secondLocation = Location(name: "Home")
        XCTAssertEqual(firstLocation, secondLocation, "Locations are not equal")
    }
    
    func testWhenLatitudeDiffers_ShouldNotBeEqual(){
        performNotEqualsTestWithLocationProperties(firstName: "Home", secondName: "Home", firstLongLat: (0.0, 1.1), secondLongLat: (0.0, 0.0))
    }
    
    func testWhenLongitudeDiffers_ShouldNotBeEqual(){
        performNotEqualsTestWithLocationProperties(firstName: "Home", secondName: "Home", firstLongLat: (0.0, 0.0), secondLongLat: (1.1, 0.0))
    }
    
    func testWhenOneHasCoordinateAndTheOtherDoesnt_ShouldNotBeEqual(){
        performNotEqualsTestWithLocationProperties(firstName: "Home", secondName: "Home", firstLongLat: (0.0,0.0), secondLongLat: nil)
    }
    
    func testWhenNameDiffers_ShouldNotBeEqual(){
        performNotEqualsTestWithLocationProperties(firstName: "Home", secondName: "Office", firstLongLat: (0.0,0.0), secondLongLat: (0.0,0.0))
    }
    
    func performNotEqualsTestWithLocationProperties(firstName: String, secondName: String, firstLongLat: (Double, Double)?, secondLongLat: (Double, Double)?, line: UInt = #line){
        
        let firstCoord : CLLocationCoordinate2D?
        
        if let firstLongLat = firstLongLat {
            firstCoord = CLLocationCoordinate2D(latitude: firstLongLat.0, longitude: firstLongLat.1)
        } else {
            firstCoord = nil
        }
        let firstLocation = Location(name: firstName, coordinates: firstCoord)
        
        let secondCoord : CLLocationCoordinate2D?
        
        if let secondLongLat = secondLongLat {
            secondCoord = CLLocationCoordinate2D(latitude: secondLongLat.0, longitude: secondLongLat.1)
        } else {
            secondCoord = nil
        }
        let secondLocation = Location(name: secondName, coordinates: secondCoord)
        
        XCTAssertNotEqual(firstLocation, secondLocation, line: line)
    }
    
    func test_CanBeSerializedAndDeserialized() {
        let location = Location(name: "Home", coordinates: CLLocationCoordinate2DMake(50.0, 6.0))
        
        let dict = location.plistDict
        
        XCTAssertNotNil(dict)
        let recreatedLocation = Location(dict: dict)
        XCTAssertEqual(location, recreatedLocation)
    }
    
}
