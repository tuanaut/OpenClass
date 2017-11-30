//
//  AnswersViewController.swift
//  OpenClass
//
//  Created by oscar on 11/14/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextField!
    @IBOutlet weak var commentAddButton: UIButton!
    
    // Fake info for testing, actual data will be from server.
    let currentUser = "Oscar"
    var recentComment = ""
    var listOfComments = ["Yes","Alright, Thanks!"]
    var listOfUsers=["Oscar","User"]
    
    // Button to add comment to Question.
    @IBAction func commentAddButton(sender: UIButton)
    {
        recentComment = commentTextBox.text!
        listOfComments.append(recentComment)
        listOfUsers.append(currentUser)
        self.commentTableView.reloadData()
    }
    
    // Starting amount of table cells.
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // Set number of rows to load into table if not one.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(listOfComments.count)
    }
    
    // Load table cells with information.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCellPrototype", for: indexPath) as! AnswersViewControllerTableViewCell
        cell.commentUserName.text = listOfUsers[indexPath.row]
        cell.commentResponse.text = listOfComments[indexPath.row]
       
        return(cell)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

