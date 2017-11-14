//
//  Users.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/13/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation

class User {
    
    let firstname: String
    let lastname: String
    let email: String
    let password: String
    let confirmPassword: String
    let accountType: String
    
    init(firstName: String, lastName: String, email: String, password: String, confirmPassword: String, accountType: String) {
        
        self.firstname = firstName
        self.lastname = lastName
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.accountType = accountType
    }
}
