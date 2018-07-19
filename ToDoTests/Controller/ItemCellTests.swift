//
//  ItemCellTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 20/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import ToDo

class ItemCellTests: XCTestCase {
    
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        _ = controller.view
        
        tableView = controller.tableView
        tableView?.dataSource = FakeDataSource()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_HasNameLabel() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
        
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testSUT_HasLocationLabel() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
        
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func testSUT_HasDateLabel() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
        
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func testConfigWithItem_SetsLabelTexts() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
        
        cell.configCellWithItem(ToDoItem(title: "First", itemDescription: nil, timeStamp: 1456150025, location: Location(name: "Home")))
        XCTAssertEqual(cell.titleLabel.text, "First")
        XCTAssertEqual(cell.locationLabel.text, "Home")
        XCTAssertEqual(cell.dateLabel.text, "22/02/2016")
    }
    
    func testTitle_ForCheckedTasks_IsStrokeThrough(){
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
        
        let toDoItem = ToDoItem(title: "First", itemDescription: nil, timeStamp: 1456150025, location: Location(name: "Home"))
        
        cell.configCellWithItem(toDoItem, checked: true)
        
        let attributedString = NSAttributedString(string: "First", attributes: [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }
}

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
