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

class AddCourseViewController: UIViewController
{
    @IBOutlet weak var CourseKeyTextField: UITextField!
    
    // Dismiss current view controller
    @IBAction func cancelButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Hide keyboard when tapped with in the view
        self.hideKeyboardWhenTappedAround()
        
        CourseKeyTextField.text?.removeAll()
    }

    //Add Button in Add Course Function
   @IBAction func EnrollStudentInCourse(_ sender: UIButton)
   {
        print ("Preparing to enroll in course.");
        let courseToEnroll = Course(courseKey: CourseKeyTextField.text!);
        print ("Course to enroll is: ");
        print(courseToEnroll.GetKey());
        courseToEnroll.CourseIsAvailable(completionHandler: {(available) -> Void in
            if (available)
            {
                // Course is available to enroll into
                let currentUser = User.GetCurrentUser();
                var currentlyEnrolledCourses = [String]();
                
                currentUser.GetEnrolledCourses(completionHandler: {(success) -> Void in
                    if (success)
                    {
                        currentlyEnrolledCourses = currentUser.GetEnrolledCoursesWithoutDatabaseAccess();
                        
                        var updateEnrolled = true;
                        
                        for course in currentlyEnrolledCourses
                        {
                            if (courseToEnroll.GetKey() == course)
                            {
                                self.displayMyAlertMessage(userMessage: "You are already enrolled in the selected course." , correct: false);
                                updateEnrolled = false;
                                break;
                            }
                        }
                        
                        if (updateEnrolled)
                        {
                            currentUser.UpdateEnrolled(enrolledCourse: courseToEnroll.GetKey(), controller: self);
                            
                            self.displayMyAlertMessage(userMessage: "Course successfully added.", correct: true);
                        }
                    }
                });
            }
            else
            {
                // Course key does not exist.
                self.displayMyAlertMessage(userMessage: "ERROR: Course does not exist.\n Try again" , correct: false)
            }
        });
    }
 

    // function to display message to user
    func displayMyAlertMessage(userMessage: String, correct: Bool)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        if(correct)
        {
            // Everything was OK, and the course was added into the user's enrolled list. Go back to Course Feed
            let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)});
            myAlert.addAction(okAction)
        }
        else
        {
            // Something went wrong, prompt user to try again
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);

            myAlert.addAction(okAction);
        }
        self.present(myAlert, animated: true, completion: nil);
    }
 

}
