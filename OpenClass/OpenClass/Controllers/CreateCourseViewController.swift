//
//  CreateCourseViewController.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class CreateCourseViewController: UIViewController {

    @IBOutlet weak var CreateCourseLabel: UILabel!
    @IBOutlet weak var CourseNameText: UITextField!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CourseDescriptionText: UITextField!
    @IBOutlet weak var CourseDescriptionLabel: UILabel!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var ProfessorText: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
    }
    
    
    @IBAction func CreateTheCourse(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        
        
        let rootref = Database.database().reference(fromURL: "https://openclass-d7aa6.firebaseio.com/")
        let courseref = rootref.child("courses").childByAutoId()
        
        
       // let newcourse = courseref.child("courses").childByAutoId()
        
        
        
        
        let thisCourse = Course(CourseName: CourseNameText.text!, CourseDescription: CourseDescriptionText.text!, ProfessorLastName: ProfessorText.text!, CourseKey: randomString(length: 5))
        
        
        
        let values = ["CourseName": thisCourse.CourseName, "CourseDescription": thisCourse.CourseDescription, "Professor": thisCourse.ProfessorLastName, "CourseKey": thisCourse.CourseKey]
     
        
        
        let databaseRef = Database.database().reference()
        let values2 = ["CourseKey": thisCourse.CourseKey]
        databaseRef.child("users").child(uid!).child("enrolled").childByAutoId().setValue(values2)
        
        courseref.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if (err != nil)
            {
                self.displayMyAlertMessage(userMessage: (err?.localizedDescription)! )
                return
            }
            else
            {
                // Display alert with confirmation.
                let myAlert = UIAlertController(title:"Alert", message: "Course Was Created!", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.performSegue(withIdentifier: "GoToCourseFeed", sender: self)});
                
                myAlert.addAction(okAction);
                self.present(myAlert, animated: true, completion: nil);
                
            }
        })
        
       
        
    }
    
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }

    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    

}
