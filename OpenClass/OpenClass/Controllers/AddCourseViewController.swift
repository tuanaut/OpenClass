//
//  AddCourseViewController.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddCourseViewController: UIViewController {

    
    @IBOutlet weak var AddCourseLabel: UILabel!
    
    @IBOutlet weak var CourseNumLabel: UILabel!
    
    @IBOutlet weak var CourseNumTextField: UITextField!
    
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var ProfessorNameTextField: UITextField!
    
    @IBOutlet weak var CourseKeyTextField: UITextField!
    @IBOutlet weak var CourseKeyLabel: UILabel!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 205, g: 35, b: 35)
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   @IBAction func addtheCourse(_ sender: UIButton) {
       
    let uid = Auth.auth().currentUser?.uid
    let databaseRef = Database.database().reference()
    let rootref = Database.database().reference().child("courses").queryOrdered(byChild: "CourseKey").queryEqual(toValue: CourseKeyTextField.text)
        rootref.observeSingleEvent(of: .value, with: {(DataSnapshot)
            in
            databaseRef.child("users").child(uid!).child("enrolled").childByAutoId().setValue(self.CourseKeyTextField.text)
                print("OK")
        })
    
    
       // let courseID = UUID().uuidString
 
        
        
    }
 
    

 

}
