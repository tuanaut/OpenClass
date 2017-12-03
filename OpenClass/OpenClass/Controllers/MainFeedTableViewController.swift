//
//  MainFeedTableViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/25/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class MainFeedTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var passedCourseKey: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Default row height
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Key: \((passedCourseKey)!)", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToNotesFeed")
        {
            let viewController = segue.destination as! NotesFeedViewController
            viewController.passedCourseKey = passedCourseKey
        }
        
        if(segue.identifier == "GoToQuestionsFeed")
        {
            let viewController = segue.destination as! QuestionFeedTableViewController
            viewController.passedCourseKey = passedCourseKey
        }
    }

    //================== TableView cell functions ==================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassNotes", for: indexPath)
            return cell
        }
        
        if (indexPath.row == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Questions", for: indexPath)
            return cell
        }
        
        if (indexPath.row == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsInCourse", for: indexPath)
            return cell
        }
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        if(indexPath.row == 0){
            performSegue(withIdentifier: "GoToNotesFeed", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if(indexPath.row == 1){
            performSegue(withIdentifier: "GoToQuestionsFeed", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

