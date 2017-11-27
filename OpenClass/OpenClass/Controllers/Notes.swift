//
//  Notes.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/18/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Notes {
    
    var ref: DatabaseReference!
    var key: String!
    
    var notesSubject: String!
    var notesDescription: String!
    var notesImageURL: String!
    //var notesID: String!



    init(notesSubject: String, notesDescription: String, notesImageURL: String){
   
    self.notesSubject = notesSubject
    self.notesDescription = notesDescription
    self.notesImageURL = notesImageURL
   
    }
    
 /*   init(snapshot: DataSnapshot){
        self.notesSubject = snapshot.value!["NotesSubject"] as! String
        self.notesDescription = snapshot.value!["NotesDescription"] as! String
        
    }*/
}
