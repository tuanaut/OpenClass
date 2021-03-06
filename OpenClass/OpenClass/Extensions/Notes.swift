//
//  Notes.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/18/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Notes
{
    var notesSubject: String
    var notesDescription: String
    var notesImageURL: String
    var notesID: String!
    var username: String
    var date: String
    

    init(notesSubject: String, notesDescription: String, notesImageURL: String, firstName: String, lastName: String, date: String, time: String, notesID: String, key: String)
    {
        self.notesSubject = notesSubject;
        self.notesDescription = notesDescription;
        self.notesImageURL = notesImageURL;
        self.username = firstName + " " + lastName;
        self.date = date + " " + time
        self.notesID = notesID;
        
    }
    
   init(snapshot: DataSnapshot)
   {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.notesSubject = snapshotvalue!["NotesSubject"] as! String
        self.notesDescription = snapshotvalue!["NotesDescription"] as! String
        self.notesImageURL = snapshotvalue!["NotesImageURL"] as! String
        self.username = snapshotvalue!["Username"] as! String
        self.date = snapshotvalue!["Date"] as! String
        self.notesID = snapshotvalue!["NotesID"] as! String
    
    }
}

