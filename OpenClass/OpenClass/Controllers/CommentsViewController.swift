//
//  CommentsViewController.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/22/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var commentsArray = [Comment]()
    var userName:String!
    var passedNotesID: String!
    var passedCourseKey: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var comment: UITextField!
    
    var databaseRef: DatabaseReference!
    {
        return Database.database().reference()
    }
    
    var storageRef: Storage!
    {
        return Storage.storage()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let currentUser = User.GetCurrentUser();
        currentUser.GetFirstName(completionHandler: {(success) -> Void in
            if (success)
            {
                self.userName = currentUser.GetFirstNameWithoutDatabaseAccess() + " ";
            }
        });
        
        currentUser.GetLastName(completionHandler: {(success) -> Void in
            if (success)
            {
                self.userName = self.userName + currentUser.GetLastNameWithoutDatabaseAccess();
            }
        });
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
   
        // Hide keyboard when tapped with in the view
        self.hideKeyboardWhenTappedAround()
        
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = 124
        // Expand row height based on amount of text
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        // Reset course array to empty every you go back to this view controller and reload table view
        commentsArray.removeAll()
        tableView.reloadData()
        fetchComments()
        tableView.reloadData()
        
        navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commentsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.commentLabel.text = commentsArray[indexPath.row].commentPosted
        cell.usernameLabel.text = commentsArray[indexPath.row].username
      
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func commentButton(_ sender: Any)
    {
        if(comment.text?.isEmpty)!
        {
            return
        }
        else
        {
            let values = ["Commenter": self.userName, "Comment": comment.text, "id": passedNotesID ]
            databaseRef.child("responses").child(passedCourseKey).child("comments").childByAutoId().setValue(values, withCompletionBlock: {(error, ref) in

                if(error == nil)
                {
                    let comment = Comment(commentPosted: self.comment.text!, username: self.userName, notesID: self.passedNotesID)
                  
                    self.commentsArray.append(comment)
                    self.tableView.reloadData()
                    
                    // Scroll down automatically when posting a new question
                    let indexPath = IndexPath(row: self.commentsArray.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                    
                    // Remove the text in textfield after posting
                    self.comment.text?.removeAll()
                }
                else
                {
                    self.displayMyAlertMessage(userMessage: (error?.localizedDescription)!)
                }
            });
        }
    }
    
    private func fetchComments()
    {
        print("notes id here")
        print(passedNotesID)
        let ref = databaseRef.child("responses").child(passedCourseKey).child("comments").queryOrdered(byChild: "id").queryEqual(toValue: passedNotesID)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot)
            in
            print("parent")
            print(snapshot)
            for childSnapshot in snapshot.children
            {
                print(childSnapshot)
                print("This is child snapshot")
                let newComment = Comment(snapshot: childSnapshot as! DataSnapshot)
                self.commentsArray.append(newComment)
            }
            self.tableView.reloadData()
        });
    }
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
}

