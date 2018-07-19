//
//  ItemManagerTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 06/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
import UIKit
@testable import ToDo

class ItemManagerTests: XCTestCase {
    
    var sut: ItemManager!
    var item: ToDoItem!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = ItemManager()
        item = ToDoItem(title: "Test")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        sut.removeAllItems()
        sut = nil
    }
    
    func testToDoCount_Initially_ShouldBeZero(){
        XCTAssertEqual(sut.toDoCount, 0, "Initially toDo count should be 0")
    }
    
    func testDoneCount_Initially_ShouldBeZero(){
        XCTAssertEqual(sut.doneCount, 0, "Initially Done count should be 0")
    }
    
    func testToDoCount_AfterAddingOneItem_IsOne() {
        sut.addItem(item)
        XCTAssertEqual(sut.toDoCount, 1, "After adding an item toDoCount should be 1")
    }
    
    func testItemAtIndex_ShouldReturnPreviouslyAddedItem(){
        sut.addItem(item)
        let returnedItem = sut.itemAtIndex(0)
        XCTAssertEqual(item, returnedItem, "Should be the same item")
    }
    
    func testCheckingItem_ChangesCountOfToDoItemsAndDoneItems(){
        sut.addItem(item)
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 0, "ToDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 1, "DoneCount should be 1")
    }
    
    func testCheckingItem_RemovesItFromTheToDoList(){
        let firstItem = ToDoItem(title: "First Item")
        let secondItem = ToDoItem(title: "Second Item")
        
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.itemAtIndex(0), secondItem)
    }
    
    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedItem(){
        sut.addItem(item)
        sut.checkItemAtIndex(0)
        
        let returnedItem = sut.doneItemAtIndex(0)
        XCTAssertEqual(item, returnedItem, "Done item should be same as checked item")
    }
    
    func testEqualItems_ShouldBeEqual(){
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "First")
        
        XCTAssertEqual(firstItem, secondItem)
    }
    
    func testWhenLocationDiffers_ShouldNotBeEqual(){
        let firstItem = ToDoItem(title: "First", itemDescription: "Descr", timeStamp: 0.0, location: Location(name: "Home"))
        let secondItem = ToDoItem(title: "First", itemDescription: "Descr", timeStamp: 0.0, location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testRemoveAllItems_ShouldResultInCountsBeingZero(){
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "Second"))
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 1, "ToDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 1, "DoneCount should be 1")
        
        sut.removeAllItems()
        XCTAssertEqual(sut.toDoCount, 0, "ToDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 0, "DoneCount should be 0")
    }
    
    func testAddingTheSameItem_DoesNotIncreaseCount(){
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "First"))
        
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func test_ToDoItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager!.addItem(firstItem)
        let secondItem = ToDoItem(title: "Second")
        itemManager!.addItem(secondItem)
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        itemManager = nil
        XCTAssertNil(itemManager)
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(1), secondItem)
    }

}
