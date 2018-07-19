//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 07/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
    
    var sut : ItemListViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = sut.view
        
        
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else {XCTFail(); return}
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.perform(addButton.action, with: addButton)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut?.tableView)
    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetTableViewDelegate() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func testItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as? UIViewController, sut)
    }
    
    func testAddItem_PresentsAddItemViewController(){
        let inputViewController = sut.presentedViewController as! InputViewController

        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        let inputViewController = sut.presentedViewController as! InputViewController

        guard let inputItemManager = inputViewController.itemManager else {XCTFail(); return}
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func testViewWillAppear_ReloadsTableView() {
        let mockTableView = MockTableView()

        sut.tableView = mockTableView
        
        sut.viewWillAppear(true)

        XCTAssertTrue(mockTableView.didCallReloadData)
    }
    
    func testItemSelectedNotification_PushesDetailVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let iVC = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        let mockNavigationController = MockNavigationController(rootViewController: iVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = iVC.view
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: self, userInfo: ["index": 1])
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return }
        guard let detailItemManager = detailViewController.itemInfo?.0 else { XCTFail(); return }
        guard let index = detailViewController.itemInfo?.1 else { XCTFail(); return }
        _ = detailViewController.view
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === iVC.itemManager)
        XCTAssertEqual(index, 1)
    }
}

extension ItemListViewControllerTests {
    class MockTableView : UITableView {
        var didCallReloadData = false
        
        override func reloadData() {
            didCallReloadData = true
        }
    }
    
    class MockNavigationController : UINavigationController {
        
        var pushedViewController : UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
