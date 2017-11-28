//
//  AnswersViewController.swift
//  OpenClass
//
//  Created by oscar on 11/14/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class AnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedUserID : String!
    var passedQuestion: String!
    var passedFirstName : String!
    var passedLastName : String!
    var passedAnswerID: String!
    var answerArray = [Comment] ()
    var databaseRef = Database.database().reference()
    
    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextField!
    @IBOutlet weak var commentAddButton: UIButton!
    
   

    
    // Button to add comment to Question.
    @IBAction func commentAddButton(sender: UIButton)
    {
        if (commentTextBox.text?.isEmpty)!
        {
            return
        }else
        {
            //Fetch Data
            let values = ["Commenter": passedFirstName, "Comment": commentTextBox.text, "id": passedAnswerID]
            databaseRef.child("comments").childByAutoId().setValue(values,withCompletionBlock: {(error,ref) in
                if (error == nil)
                {
                    let answer = Comment(commentPosted: self.commentTextBox.text!, username: self.passedFirstName, notesID: self.passedAnswerID)
                    self.answerArray.append(answer)
                    self.commentTableView.reloadData()
                    
                    let indexPath = IndexPath(row: self.answerArray.count - 1, section: 0)
                    self.commentTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                    self.commentTextBox.text?.removeAll()
                }else
                {
//                    self.displayMyAlertMessage(userMessage: (error?.localizedDescription)!)
                }
                
            })
            
        }
        
    }
    
    // Starting amount of table cells.
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // Set number of rows to load into table if not one.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(answerArray.count)
    }
    
    // Load table cells with information.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCellPrototype", for: indexPath) as! AnswersViewControllerTableViewCell
        cell.commentUserName.text = answerArray[indexPath.row].commentPosted
        cell.commentResponse.text = passedFirstName
       
        return(cell)
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Hiddes Keyboard when tapped in the view
        self.hideKeyboardWhenTappedAround()
        // Dynamically increase amount of space in cell
        commentTableView.rowHeight = UITableViewAutomaticDimension
        // Do not show empty cells
        commentTableView.tableFooterView = UIView(frame: CGRect.zero)
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        answerArray.removeAll()
        commentTableView.reloadData()
        fetchAnswers()
        commentTableView.reloadData()
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func fetchAnswers()
    {
        let ref = databaseRef.child("comments").queryOrdered(byChild: "id").queryEqual(toValue: passedAnswerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot)
            in
            for childSnapshot in snapshot.children {
                let newAnswer = Comment(snapshot: childSnapshot as! DataSnapshot)
                self.answerArray.append(newAnswer)
            }
            self.commentTableView.reloadData()
            
        })
    }
    
    
    override func didReceiveMemoryWarning()
    {
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
