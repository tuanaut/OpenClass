//
//  AnswersViewController.swift
//  OpenClass
//
//  Created by oscar on 11/14/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextField!
    
    @IBOutlet weak var commentAddButton: UIButton!
    
    let currentUser = "Oscar"
    var recentComment = ""
    var listOfComments = ["Yes","Alright, Thanks!"]
    var listOfUsers=["Oscar","Oscar2"]
    
    @IBAction func commentAddButton(sender: UIButton)
    {
        recentComment = commentTextBox.text!
        listOfComments.append(recentComment)
        listOfUsers.append(currentUser)
        self.commentTableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(listOfComments.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCellPrototype", for: indexPath) as! AnswersViewControllerTableViewCell
        cell.commentUserName.text = listOfUsers[indexPath.row]
        cell.commentResponse.text = listOfComments[indexPath.row]
       
        return(cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
