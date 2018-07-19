//
//  ItemListDataProviderTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 07/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTests: XCTestCase {
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        _ = controller.view
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }
    
    override func tearDown() {
        super.tearDown()
        sut.itemManager?.removeAllItems()
        sut.itemManager = nil
    }
    
    func testNumberOfSections_IsTwo() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }

    func testNumberOfItemsInFirstSection_IsToDoCount() {
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        sut.itemManager?.addItem(ToDoItem(title: "Test2"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfItemsInSecondDection_IsDoneCount() {
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        sut.itemManager?.addItem(ToDoItem(title: "Test2"))
        
        sut.itemManager?.checkItemAtIndex(0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)

        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRow_ReturnsItemCell() {
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
        
        XCTAssertTrue(cell is ItemCell)
    }
    
    func testCellForRow_DeqeuesCell() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)
        
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testConfigCell_GetsCalledInCellForRow() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)

        let toDoItem = ToDoItem(title: "Test")
        sut.itemManager?.addItem(toDoItem)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.toDoItem, toDoItem)
    }
    
    func testCellsInSectionTwo_GetsConfiguredWithDoneItem() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)
        
        let firstItem = ToDoItem(title: "First Item", itemDescription: "First Description")
        sut.itemManager?.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "Second Item", itemDescription: "Second Description")
        sut.itemManager?.addItem(secondItem)
        
        sut.itemManager?.checkItemAtIndex(1)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        
        XCTAssertEqual(cell.toDoItem, secondItem)
    }
    
    
    func testDeletionButtonInFirstSection_ShowsTitleCheck() {
        sut.itemManager?.addItem(ToDoItem(title: "Yes"))
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt:IndexPath(row: 0, section: 0))
        XCTAssertEqual(deleteButtonTitle, "Check")
    }
    
    func testDeletionButtonInSecondSection_ShowsTitleUncheck() {
        sut.itemManager?.addItem(ToDoItem(title: "Yes"))
        sut.itemManager?.checkItemAtIndex(0)
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt:IndexPath(row: 0, section: 1))
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }
    
    func testCheckingAnItem_ChecksItInTheItemManager() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }
    
    func testUncheckingAnItem_UnchecksItInTheItemManager() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        sut.itemManager?.checkItemAtIndex(0)
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }
    
    func testSelectingCell_SendsNotification() {
        let item = ToDoItem(title: "First")
        sut.itemManager?.addItem(item)
        
        expectation(forNotification: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else { return false }
            return index == 0
        }
        
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}

extension ItemListDataProviderTests {
    class MockTableView: UITableView {
        var cellGotDequeued = false
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        class func mockTableViewWithDataSource(dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                                              style: .plain)
            
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            return mockTableView
        }
    }
    
    class MockItemCell: ItemCell {
        var toDoItem : ToDoItem?
        override func configCellWithItem(_ item: ToDoItem, checked: Bool = false){
            toDoItem = item
        }
    }
}

