//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 21/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        _ = sut.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        sut.itemInfo?.0.removeAllItems()
    }

    func test_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func test_HasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
    }
    
    func test_HasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
    }
    
    func test_HasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
    }
    
    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }
    
    func testSettingItemInfo_SetsTextsForLabels() {
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "The title", itemDescription: "The description", timeStamp: 1456150025, location: Location(name: "Home", coordinates: coordinate)))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "The title")
        XCTAssertEqual(sut.dateLabel.text, "22/02/2016")
        XCTAssertEqual(sut.locationLabel.text, "Home")
        XCTAssertEqual(sut.descriptionLabel.text, "The description")
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude,
                                   coordinate.latitude,
                                   accuracy: 0.001)
        
        
    }
    
    func testCheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "The title"))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
        
    }
    
}
