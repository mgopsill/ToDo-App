//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Mike Gopsill on 13/12/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(password: String, account: String)
    func deletePasswordForAccount(account: String)
    func passwordForAccount(account: String) -> String?
}
