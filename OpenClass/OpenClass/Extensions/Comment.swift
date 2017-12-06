//
//  Comment.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/22/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Comment
{
    let commentPosted: String
    let username: String
    let date: String
    let notesID: String
    
    init(commentPosted: String, username: String, date: String, time: String, notesID: String)
    {
        self.commentPosted = commentPosted
        self.username = username
        self.date = date + " " + time
        self.notesID = notesID
    }
    
    init(snapshot: DataSnapshot)
    {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.commentPosted = snapshotvalue!["Comment"] as! String
        self.username = snapshotvalue!["Commenter"] as! String
        self.date = snapshotvalue!["Date"] as! String
        self.notesID = snapshotvalue!["id"] as! String
    }
}

