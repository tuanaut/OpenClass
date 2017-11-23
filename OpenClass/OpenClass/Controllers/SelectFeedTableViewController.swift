//
//  SelectFeedTableViewController.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/22/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class SelectFeedTableViewController: UITableViewController {

    var passedCourseKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         navigationController?.isNavigationBarHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
 


    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
    
        if(indexPath.row == 0){
            performSegue(withIdentifier: "GoToNotesFeed", sender: self)
        }
        else if(indexPath.row == 1){
            performSegue(withIdentifier: "GoToQuestionsFeed", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToNotesFeed"){
            let viewController = segue.destination as! NotesFeedViewController
            viewController.passedCourseKey = passedCourseKey
            
        }
    }
}
