//
//  Users.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/13/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import Firebase

class User {
    
  
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var confirmPassword: String
    var accountType: String
    
    
    
    init(firstName: String, lastName: String, email: String, password: String, confirmPassword: String, accountType: String) {
        
        self.firstname = firstName
        self.lastname = lastName
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.accountType = accountType
    }
    
    init(snapshot: DataSnapshot){
        let snapshotvalue = snapshot.value as? NSDictionary
        self.firstname = snapshotvalue!["firstname"] as! String
        self.lastname = snapshotvalue!["lastname"] as! String
        self.email = snapshotvalue!["email"] as! String
        self.password = snapshotvalue!["password"] as! String
        self.accountType = snapshotvalue!["accounttype"] as! String
        self.confirmPassword = ""
    }
    
    
}



