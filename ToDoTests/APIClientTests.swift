//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by Mike Gopsill on 13/12/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import ToDo


class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword() {
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "dasdöm",
                              password: "%&34",
                              completion: completion)
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let expectedUsername = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        XCTAssertEqual(urlComponents?.percentEncodedQuery, "username=\(expectedUsername)&password=\(expectedPassword)")
    }
    
    func testLogin_CallsResumeOfDataTask() {
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "dasdom", password: "1234", completion: completion)
        
        XCTAssert(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testLogin_SetsToken() {
        let mockKeychainManager = MockKeychainManager()
        sut.keychainManager = mockKeychainManager
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "dasdom", password: "1234", completion: completion)

        let responseDict = ["token":"1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        
        mockURLSession.completionHandler?(responseData, nil, nil)
        
        let token = mockKeychainManager.passwordForAccount(account: "token")

        XCTAssertEqual(token, responseDict["token"])
    }
    
    func testLogin_ThrowsErrorWhenJSONIsInvalid() {
        
        var theError: Error?
        let completion = {(error: Error?) in theError = error}
        sut.loginUserWithName(username: "dasdom", password: "1234", completion: completion)
        
        let responseData  = Data()
        mockURLSession.completionHandler?(responseData,nil,nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenJSONIsNil() {
        
        var theError: Error?
        let completion = {(error: Error?) in theError = error}
        sut.loginUserWithName(username: "dasdom", password: "1234", completion: completion)
        
        mockURLSession.completionHandler?(nil,nil,nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenResponseHasError() {
        var theError: Error?
        let completion = {(error: Error?) in theError = error}
        sut.loginUserWithName(username: "dasdom", password: "1234", completion: completion)
        
        let responseDict = ["token":"1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        
        mockURLSession.completionHandler?(responseData, nil, error)
        
        XCTAssertNotNil(theError)
    }
    
}

extension APIClientTests {
    class MockURLSession : ToDoURLSession {
        
        typealias Handler = (Data?, URLResponse?, Error?) -> Swift.Void
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockURLSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
        
    }
    
    class MockKeychainManager : KeychainAccessible {
        var passwordDict = [String:String]()

        func setPassword(password: String, account: String) {
            passwordDict[account] = password
        }
        
        func deletePasswordForAccount(account: String) {
            passwordDict.removeValue(forKey: account)
        }
        
        func passwordForAccount(account: String) -> String? {
            return passwordDict[account]
        }
    }
}
