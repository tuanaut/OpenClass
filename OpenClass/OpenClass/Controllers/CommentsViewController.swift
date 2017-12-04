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
    var currComment: String!
    var bottomConstraint: NSLayoutConstraint?
    var borderBottomConstraint: NSLayoutConstraint?
    var tableViewConstraint: NSLayoutConstraint?
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var MessageInputView: UIView!
    @IBOutlet weak var borderView: UIView!
    
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
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        
        // Expand row height based on amount of text
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Set up constraints for when keyboard shows
        bottomConstraint = NSLayoutConstraint(item: MessageInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        borderBottomConstraint = NSLayoutConstraint(item: borderView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50)
        view.addConstraint(borderBottomConstraint!)
        
        tableViewConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -51)
        view.addConstraint(tableViewConstraint!)
        
        // Set up keyboard showing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        // Set up keyboard dismissing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // Set up the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.orange
        refreshControl.backgroundColor = UIColor.darkGray
        tableView.addSubview(refreshControl)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let row:Comment = commentsArray[indexPath.row]
        
        currComment = row.commentPosted
        comment.endEditing(true)
        
        // Unhighlight the selected row after all procedures has been done
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.commentLabel.text = commentsArray[indexPath.row].commentPosted
        cell.usernameLabel.text = commentsArray[indexPath.row].username
        cell.dateLabel.text = commentsArray[indexPath.row].date
      
        return cell
    }
    
    @IBAction func commentButton(_ sender: Any)
    {
        if(comment.text?.isEmpty)!
        {
            return
        }
        else
        {

            let date = Date()
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            // Get current date
            let currDate = formatter.string(from: date)
            
            // Get current time
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            let currTime = "\(hour):\(minutes):\(seconds)"
            
            let values = ["Commenter": self.userName, "Comment": comment.text!, "Date": currDate + " " + currTime, "id": passedNotesID]
            databaseRef.child("responses").child(passedCourseKey).child("comments").childByAutoId().setValue(values, withCompletionBlock: {(error, ref) in


                if(error == nil)
                {
                    let comment = Comment(commentPosted: self.comment.text!, username: self.userName, date: currDate, time: currTime, notesID: self.passedNotesID)
                  
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
    
    // Handles how the textfields should appear when keyboard is showing
    @objc func handleKeyboardNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            // Get the x, y, width, height of keyboard
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            // Determine if keyboard is showing or not
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            // Adjust the constraints if keyboard is showing or dismissing
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            borderBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height + (-50) : -50
            tableViewConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height + (-51) : -51
            
            // Smooth transition of textfield going up and down
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations:
                {
                    self.view.layoutIfNeeded();
            }, completion: {(completed) in
            });
        }
    }
    
    @objc func refreshData() {
        
        // Uncomment this and refresh to test it
        //commentsArray.append(Comment(commentPosted: "Hello", username: "Bob", date: "Today", time: "Now", notesID: "xxxxxxx"))
        commentsArray.removeAll();
        fetchComments();
        tableView.reloadData();
        refreshControl.endRefreshing();
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y;
        
        if (offset < -232)
        {
            self.refreshControl.attributedTitle = NSAttributedString(string: "You Can Let Go Now!", attributes: [NSAttributedStringKey.foregroundColor: self.refreshControl.tintColor, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]);
        }
        else
        {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading the Comments...", attributes: [NSAttributedStringKey.foregroundColor: self.refreshControl.tintColor, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]);
        }
        
        refreshControl.backgroundColor = UIColor.darkGray;
    }
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
}

