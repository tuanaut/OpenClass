//
//  QuestionFeedTableViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/26/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class QuestionFeedTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var QuestionTextField: UITextField!
    @IBOutlet weak var MessageInputView: UIView!
    @IBOutlet weak var BorderView: UIView!
    
    var QuestionsArray = [Question]()
    var passedCourseKey: String!
    var FirstName: String!
    var LastName: String!
    var currQuestion: String!
    var UserID: String! = Auth.auth().currentUser?.uid
    var passAnswersID: String!
    var bottomConstraint: NSLayoutConstraint?
    var borderBottomConstraint: NSLayoutConstraint?
    var tableViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Default row height
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        
        // Expand row height based on amount of text
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Set navigation bar
        navigationController?.isNavigationBarHidden = false
        
        // Set up constraints for when keyboard shows
        bottomConstraint = NSLayoutConstraint(item: MessageInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        borderBottomConstraint = NSLayoutConstraint(item: BorderView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50)
        view.addConstraint(borderBottomConstraint!)
        
        tableViewConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -51)
        view.addConstraint(tableViewConstraint!)
        
        // Set up keyboard showing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        // Set up keyboard dismissing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let currentUser = User.GetCurrentUser();
        currentUser.GetFirstName(completionHandler: {(success) -> Void in
            if (success)
            {
                self.FirstName = currentUser.GetFirstNameWithoutDatabaseAccess();
            }
        });

        currentUser.GetLastName(completionHandler: {(success) -> Void in
            if (success)
            {
                self.LastName = currentUser.GetLastNameWithoutDatabaseAccess();
            }
        });
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        // Reset course array to empty every you go back to this view controller and reload table view
        QuestionsArray.removeAll()
        tableView.reloadData()
        fetchQuestions()
        tableView.reloadData()
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "GoToSelectedAnswers"){
            let viewController = segue.destination as! AnswersViewController
            viewController.passedUserID = UserID
            viewController.passedFirstName = FirstName
            viewController.passedLastName = LastName
            viewController.passedCurrentQuestion = currQuestion
            viewController.passedAnswerID = passAnswersID
//
        }
    }
    
    //================== TableView cell functions ==================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return QuestionsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPath = tableView.indexPathForSelectedRow!
        let row:Question = QuestionsArray[indexPath.row]
        
        currQuestion = row.Question
        passAnswersID = row.AnswersID
        QuestionTextField.endEditing(true)
        
        // Unhighlight the selected row after all procedures has been done
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "GoToSelectedAnswers", sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.NameLabel.text = QuestionsArray[indexPath.row].Name
        cell.DateLabel.text = QuestionsArray[indexPath.row].Date
        cell.QuestionLabel.text = QuestionsArray[indexPath.row].Question
        return cell
    }
    //======================================================

    // Submits the users question into the database and displays it
    @IBAction func PostButton(_ sender: Any)
    {
        if (QuestionTextField.text!.isEmpty)
        {
            return;
        }
        else
        {
            let questionRef = Database.database().reference().child("questions").child(passedCourseKey).childByAutoId()
            let answersID = NSUUID().uuidString
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
            
            let values = ["Name": FirstName + " " + LastName, "Date": currDate + " " + currTime, "Question": QuestionTextField.text!, "CourseKey": passedCourseKey, "Uid": UserID, "AnswersID": answersID]
            
            questionRef.setValue(values, withCompletionBlock: {(error, ref) in
                if(error == nil) {
                    
                    let question = Question(FirstName: self.FirstName, LastName: self.LastName, Date: currDate, Time: currTime, Question: self.QuestionTextField.text!, Key: self.passedCourseKey, Uid: self.UserID, AnswersID: answersID)
                    
                    //self.QuestionsArray.insert(question, at: 0)
                    self.QuestionsArray.append(question)
                    self.tableView.reloadData()
                    
                    // Scroll down automatically when posting a new question
                    let indexPath = IndexPath(row: self.QuestionsArray.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                    
                    // Remove the text in textfield after posting
                    self.QuestionTextField.text?.removeAll()
                }
                else
                {
                    self.displayMyAlertMessage(userMessage: (error?.localizedDescription)!)
                }
                
            })
            
        }
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
    
    // Gets a query of all the questions in the course
    private func fetchQuestions()
    {
        let query = Database.database().reference().child("questions").child(self.passedCourseKey).queryOrderedByKey()

        query.observeSingleEvent(of: .value, with: {(questions)
            in

            for question in questions.children
            {
                let newQuestion = Question(snapshot: question as! DataSnapshot)
                self.QuestionsArray.append(newQuestion)
                print(question)
            }
            self.tableView.reloadData()
        });
    }
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
 
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)});
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil);
    }
}

