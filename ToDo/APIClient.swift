//
//  APIClient.swift
//  ToDo
//
//  Created by Mike Gopsill on 13/12/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import Foundation

protocol ToDoURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

enum WebServiceError: Error {
    case DataEmptyError
    case ResponseError
}


class APIClient {
    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager : KeychainAccessible?
    
    func loginUserWithName(username: String, password: String, completion: @escaping (Error?) -> Void) {
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        guard let url = URL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else {fatalError()}
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {   completion(WebServiceError.ResponseError)
                return
            }
            if data != nil {
                do {
                    let responseDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(password: token, account: "token")
                } catch {
                    completion(error)
                }
            } else {
                completion(WebServiceError.DataEmptyError)
            }
        }
        task.resume()
        
    }
}

extension URLSession : ToDoURLSession {
    
}
