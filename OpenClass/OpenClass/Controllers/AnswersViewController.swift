//
//  AnswersViewController.swift
//  OpenClass
//
//  Created by Oscar on 11/14/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class AnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedCourseKey : String!
    var passedUserID : String!
    var passedQuestion: String!
    var passedFullName : String!
    var passedAnswerID: String!
    var passedCurrentQuestion: String!
    var answerArray = [Comment] ()
    var databaseRef = Database.database().reference()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var bottomConstraint: NSLayoutConstraint?
    var tableViewConstraint: NSLayoutConstraint?
    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextField!
    @IBOutlet weak var commentAddButton: UIButton!
    @IBOutlet weak var MessageInputView: UIView!
    
    // Button to add comment to Question.
    @IBAction func commentAddButton(sender: UIButton)
    {
        if (commentTextBox.text?.isEmpty)!
        {
            return
        }else
        {
            let date = Date()
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let currDate = formatter.string(from: date)
            
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            let currTime = "\(hour):\(minutes):\(seconds)"
            let actualDate = currDate + " " + currTime
            
            //Fetch Data
            let values = ["Comment": commentTextBox.text!, "Commenter": passedFullName, "Date": actualDate, "id": passedAnswerID]
            
            databaseRef.child("responses").child(passedCourseKey).child("answers").childByAutoId().setValue(values,withCompletionBlock: {(error,ref) in
                if (error == nil)
                {
                    let answer = Comment(commentPosted: self.commentTextBox.text!, username: self.passedFullName, date: currDate, time: currTime, notesID: self.passedAnswerID)
                    self.answerArray.append(answer)
                    self.commentTableView.reloadData()
                    self.commentTableView.rowHeight = UITableViewAutomaticDimension
                    
                    
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
        cell.commentResponse.text = answerArray[indexPath.row].commentPosted
        cell.commentUserName.text = answerArray[indexPath.row].username
        cell.commentDate.text = answerArray[indexPath.row].date
       
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
        
        // Add refresh
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.orange
        refreshControl.backgroundColor = UIColor.darkGray
        commentTableView.addSubview(refreshControl)
        
        // Change Navigation Icon
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Question Feed"), style: .plain, target: self, action: #selector(GoBack))
        
        // Set up constraints for when keyboard shows
        bottomConstraint = NSLayoutConstraint(item: MessageInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        tableViewConstraint = NSLayoutConstraint(item: commentTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -51)
        view.addConstraint(tableViewConstraint!)
        
        // Set up keyboard showing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        // Set up keyboard dismissing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        answerArray.removeAll()
        commentTableView.reloadData()
        fetchAnswers()
        commentTableView.reloadData()
        
        navigationController?.isNavigationBarHidden = false
    }
    
    
    // Answers from database.
    private func fetchAnswers()
    {
        let ref = databaseRef.child("responses").child(passedCourseKey).child("answers").queryOrdered(byChild: "id").queryEqual(toValue: passedAnswerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot)
            in
            for childSnapshot in snapshot.children {
                let newAnswer = Comment(snapshot: childSnapshot as! DataSnapshot)
                self.answerArray.append(newAnswer)
            }
            self.commentTableView.rowHeight = UITableViewAutomaticDimension
            
            self.commentTableView.reloadData()
            
        })
    }
    
    
    // Refresh Function
    @objc func refreshData()
    {
        answerArray.removeAll();
        fetchAnswers();
        commentTableView.reloadData();
        refreshControl.endRefreshing();
    }
    
    
    // Refresh Action Handle
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offset = scrollView.contentOffset.y;
        
        if (offset < -232)
        {
            self.refreshControl.attributedTitle = NSAttributedString(string: "You Can Let Go Now!", attributes: [NSAttributedStringKey.foregroundColor: self.refreshControl.tintColor, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]);
        }
        else
        {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading the Answers...", attributes: [NSAttributedStringKey.foregroundColor: self.refreshControl.tintColor, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]);
        }
        
        refreshControl.backgroundColor = UIColor.darkGray;
    }
    
    
    @objc func GoBack()
    {
        _ = navigationController?.popViewController(animated: true);
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
            tableViewConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height + (-51) : -51
            
            // Smooth transition of textfield going up and down
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations:
                {
                    self.view.layoutIfNeeded();
            }, completion: {(completed) in
            });
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

