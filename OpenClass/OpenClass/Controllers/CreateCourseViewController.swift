//
//  CreateCourseViewController.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class CreateCourseViewController: UIViewController
{
    @IBOutlet weak var CourseNameText: UITextField!;
    @IBOutlet weak var CourseDescriptionText: UITextField!;
    
    // Dismiss current view controller
    @IBAction func cancelButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();

        // Hide keyboard when tapped with in the view
        self.hideKeyboardWhenTappedAround();
        
        CourseNameText.text?.removeAll();
        CourseDescriptionText.text?.removeAll();
    }
    
    // Create Button Functionality in Create Course Page
    @IBAction func CreateCourse(_ sender: UIButton)
    {
        let currentUser = User.GetCurrentUser();
        
        // Create a Course class object
        let thisCourse = Course(courseName: CourseNameText.text!, courseDescription: CourseDescriptionText.text!, courseCreator: currentUser.GetAccountID());
        
        thisCourse.WriteCourse(controller:self, completionHandler: {(success) -> Void in
            // Add the new course to the "enrolled" courses
            // for the professor who just created it; acts as
            // the "created courses" for that professor
            currentUser.UpdateEnrolled(enrolledCourse: thisCourse.GetKey(), controller: self);
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

