//
//  Course.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Course {
    
    let CourseName: String
    let CourseDescription: String
    let ProfessorLastName: String
    let CourseKey: String
    
    init(CourseName: String, CourseDescription: String, ProfessorLastName: String, CourseKey: String) {
        
        self.CourseName = CourseName
        self.CourseDescription = CourseDescription
        self.ProfessorLastName = ProfessorLastName
        self.CourseKey = CourseKey
    }
    
    init(snapshot: DataSnapshot){
        let snapshotvalue = snapshot.value as? NSDictionary
        self.CourseName = snapshotvalue!["CourseName"] as! String
        self.CourseDescription = snapshotvalue!["CourseDescription"] as! String
        self.ProfessorLastName = snapshotvalue!["Professor"] as! String
        self.CourseKey = snapshotvalue!["CourseKey"] as! String
    }
}
