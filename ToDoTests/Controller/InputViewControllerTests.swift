//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 05/12/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        
        _ = sut.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }

    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        sut.titleTextField.text = "Test Title"
        sut.dateTextField.text = "22/02/2016"
        sut.locationTextField.text = "Office"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.itemManager = ItemManager()

        sut.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316, -122.0300)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test Title", itemDescription: "Test Description", timeStamp: 1456099200.0, location: Location(name: "Office", coordinates: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
    func testSave_SavesItemWithTitleOnly(){
        sut.titleTextField.text = "Test Title"
        sut.itemManager = ItemManager()
        sut.save()
        
        let item = sut.itemManager?.itemAtIndex(0)
        let testItem = ToDoItem(title: "Test Title")
        
        XCTAssertEqual(item, testItem)
    }
    
    func testSave_SavesItemWithTitleAndOtherAttributes() {
        sut.titleTextField.text = "Test Title"
        sut.descriptionTextField.text = "Test Description"
        sut.dateTextField.text = "22/02/2016"
        sut.itemManager = ItemManager()
        sut.save()
        
        let item = sut.itemManager?.itemAtIndex(0)
        let testItem = ToDoItem(title: "Test Title", itemDescription: "Test Description", timeStamp: 1456099200.0)
        
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction(){
        let saveButton: UIButton = sut.saveButton
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail(); return
        }
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_GeocoderWorksAsExpected() {
        let expect = expectation(description: "Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") { (placemarks, error) -> Void in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            XCTAssertEqual(latitude, 37.3316833, accuracy: 0.0000001)
            XCTAssertEqual(longitude, -122.0301031, accuracy: 0.0000001)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
    
}

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
                return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
    
    class MockInputViewController : InputViewController {
        var dismissGotCalled = false
        override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
            dismissGotCalled = true
        }
    }
    
    
}


