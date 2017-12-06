//
//  Question.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/26/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import Firebase

class Question
{
    let Name: String
    let Date: String
    let Question: String
    let AnswersID: String
    let SubmitterUid: String
    

    init(FirstName: String, LastName: String, Date: String, Time: String, Question: String, SubmitterUid: String, AnswersID: String)
    {
        self.SubmitterUid = SubmitterUid
        self.Name = FirstName + " " + LastName
        self.Date = Date + " " + Time
        self.Question = Question
        self.AnswersID = AnswersID
    }
    
    init(snapshot: DataSnapshot)
    {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.Name = snapshotvalue!["Name"] as! String
        self.Date = snapshotvalue!["Date"] as! String
        self.Question = snapshotvalue!["Question"] as! String
        self.SubmitterUid = snapshotvalue!["SubmitterUid"] as! String
        self.AnswersID = snapshotvalue!["AnswersID"] as! String
     }
}

