//
//  QuestionFeed.swift
//  OpenClass
//
//  Created by Ariana Handzel on 11/21/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class QuestionFeed: UIView {
    
    var question: String
    
    @IBOutlet weak var questiontext: UITextField!
    // text entered into the "ask a question"
    
    @IBOutlet weak var questiontable: UITableView!
    // table view
    
    @IBOutlet weak var questioncell: UITableViewCell!
    
    
    @IBOutlet weak var question1_text: UILabel!
    @IBOutlet weak var question2_text: UILabel!
    
    @IBAction func post(_ sender: Any) {
        
        self.question = String?(questiontext.text!)!
        
        // store the text of the question into a string
        // variable, then send to firebase somehow to
        // be able to display at the top of the question feed?
        //
        
    }
    
    
}
