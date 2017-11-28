//
//  AddCourseViewController.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddCourseViewController: UIViewController {

    @IBOutlet weak var CourseNumTextField: UITextField!
    @IBOutlet weak var ProfessorNameTextField: UITextField!
    @IBOutlet weak var CourseKeyTextField: UITextField!
    
    // Dismiss current view controller
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard when tapped with in the view
        self.hideKeyboardWhenTappedAround()
        
        CourseNumTextField.text?.removeAll()
        ProfessorNameTextField.text?.removeAll()
        CourseKeyTextField.text?.removeAll()
    }

    //Add Button in Add Course Function
   @IBAction func addtheCourse(_ sender: UIButton) {
    
    let databaseRef = Database.database().reference()
    
    //Query for reference with the coursekey = to the coursekey in text field, will return course with coursekey entered
    let rootref = Database.database().reference().child("courses").queryOrdered(byChild: "CourseKey").queryEqual(toValue: CourseKeyTextField.text)
    
        rootref.observeSingleEvent(of: .value, with: {(DataSnapshot)
            in
            
          // if there's no data at that reference, that means course was not found to be added by student
            if(!DataSnapshot.exists())
            {
                self.displayMyAlertMessage(userMessage: "ERROR: Course was not added \n Try again" , correct: false)
            }
            // if the course is in the database
            else
            {
                //not sure if this is needed
                if(DataSnapshot.value != nil)
                {
                    //check in the course and make sure the textfields entered match the data in the database
                    for snap in DataSnapshot.children
                    {
                        let userSnap = snap as! DataSnapshot
                       
                        let dictionary = userSnap.value as! [String:AnyObject]
                
                        let uid = Auth.auth().currentUser?.uid
                        // let dictionary = DataSnapshot.value as? [String: AnyObject]
                        
                        let coursename: String = (dictionary["CourseName"] as? String)!
                        let coursekey: String = (dictionary["CourseKey"] as? String)!
                        let professor: String = (dictionary["Professor"] as? String)!
                        
                        // if everything matches
                        if(coursename == self.CourseNumTextField.text! && coursekey ==
                            self.CourseKeyTextField.text! && professor == self.ProfessorNameTextField.text!){
                            let checkIfCourseExistsRef = databaseRef.child("users").child(uid!).child("enrolled")
                            checkIfCourseExistsRef.observeSingleEvent(of: .value, with: {(checks)
                                //Now, check if the user is already enrolled in this course
                                in
                                //Right now, initialize that the course has not been added yet
                                var alreadyAdded:Bool = false
                                //So, check in all the enrolled courses of the student
                                for check in checks.children
                                {
                                    
                                let tempCheck = check as! DataSnapshot
                                let enrolledCourse = tempCheck.value as! [String:AnyObject]
                                    
                                // This checks the coursekey of the text field with the coursekey of the enrolled course in the database
                                let lookingForKey: String = (enrolledCourse["CourseKey"]as? String)!
                             
                                //Maybe Comparing keys to make sure course doesn't already exist is not enough.
                                    //Can add professor name and course name too if needed
                                // let lookingForProf: String = (enrolledCourse["Professor"] as? String)!
                                //let lookingForClassName: String = (enrolledCourse["CourseName"] as? String)!
                                    
                                    //if the coursekey matches the course key found under enrolled in the database, then the course has already been added. Break, stop looking
                                    if(lookingForKey == self.CourseKeyTextField.text)
                                    {
                                        //course is already added
                                        alreadyAdded = true
                                        break
                                    }
                                }
                                
                                //If the course the user wants to add is already added, alert user
                                if(alreadyAdded)
                                {
                                    self.displayMyAlertMessage(userMessage: "Course has already been added", correct: false)
                                }
                                //If it hasn't been added, then add in enrolled list for student
                                else
                                {
                                databaseRef.child("users").child(uid!).child("enrolled").childByAutoId().setValue(["CourseKey": self.CourseKeyTextField.text])
                                
                                    self.displayMyAlertMessage(userMessage: "Course has been added!", correct: true)
                                }
                            })
                        }
                        //not sure if this is needed
                        else
                        {
                            self.displayMyAlertMessage(userMessage: "ERROR: Course was not added \n Try again" , correct: false)
                        }
                    }
                }
            }
        })
 
    }
 

    // function to display message to user
    func displayMyAlertMessage(userMessage: String, correct: Bool)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        // if everything was OK, and the course was added into the user's enrolled list. Go back to Course Feed
        if(correct){
            let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)});
            myAlert.addAction(okAction)
        }
            // Something went wrong, prompt user to try again
        else{
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);

            myAlert.addAction(okAction);
        }
        self.present(myAlert, animated: true, completion: nil);
    }
 

}
