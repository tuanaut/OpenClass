//
//  CourseFeedViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/6/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class CourseFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    
    @IBOutlet weak var tableView: UITableView!
    
    var userCourses: [String] = []
    var coursesArray = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Default row height
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        
        // Expand row height based on amount of text
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Set navigation bar
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(AddCourse))

        tableView.reloadData()
    }
    
    @objc func AddCourse() {
        
        let uid = Auth.auth().currentUser?.uid
    Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            
        let dictionary = DataSnapshot.value as? [String: AnyObject]
        let acctType: String = (dictionary!["accounttype"] as? String)!
        if ( acctType == "0"){
            self.performSegue(withIdentifier: "GoToAddCourse", sender: self)
        
        }
        else{
                self.performSegue(withIdentifier: "GoToCreateCourse", sender: self)
        }
        
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //fetchCourses()
        navigationController?.isNavigationBarHidden = false
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            handleLogout()
        }
        else{
            fetchCourses()
            tableView.reloadData()
        }
        
    }
    
    @objc func handleLogout()
    {

        do
        {
            try Auth.auth().signOut()
        }
        catch let logoutError
        {
            print(logoutError)
        }
        
        // Successfully logged out
        _ = navigationController?.popToRootViewController(animated: true)
    }

    

    // TableView cell functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Drop Crouse"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            coursesArray.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseFeedTableViewCell
        cell.CourseNumberLabel.text = coursesArray[indexPath.row].CourseName
        cell.CourseNameLabel.text = coursesArray[indexPath.row].CourseDescription
        return cell
    }
 
    // Get the user's enrolled courses
    private func fetchCourses(){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        let userRef = ref.child("users").child(uid!).child("enrolled").queryOrdered(byChild: "CourseKey")
        
        userRef.observeSingleEvent(of: .value, with: {(snapshot)
            in
            
            for childSnapshot in snapshot.children {
                let tempSnapshot = childSnapshot as! DataSnapshot
                let tempDictionary = tempSnapshot.value as! NSDictionary
                let tempCourse = tempDictionary["CourseKey"]! as! String
                //self.userCourses.append(tempCourse["CourseKey"]! as! String)
                //print(childSnapshot)
                
                let query = ref.child("courses").queryOrdered(byChild: "CourseKey").queryEqual(toValue: tempCourse)
                
                query.observeSingleEvent(of: .value, with: {(courses)
                    in
                    
                    //var newCoursesArray = [Course]()
                    for course in courses.children {
                        let newCourse = Course(snapshot: course as! DataSnapshot)
                        //newCoursesArray.append(newCourse)
                        //newCoursesArray.insert(newCourse, at: 0)
                        self.coursesArray.append(newCourse)
                        //print(course)
                    }
                    //self.coursesArray = newCoursesArray
                    self.tableView.reloadData()
                })
                
                
            }
        })
        
        
       /* for coursekey in userCourses {
            let query = ref.child("courses").queryOrdered(byChild: "CourseKey").queryEqual(toValue: coursekey)
            
            query.observeSingleEvent(of: .value, with: {(courses)
                in
                
                var newCoursesArray = [Course]()
                for course in courses.children {
                    let newCourse = Course(snapshot: course as! DataSnapshot)
                    newCoursesArray.append(newCourse)//.insert(newCourse, at: 0)
                }
                self.coursesArray = newCoursesArray
                self.tableView.reloadData()
            })
            //self.coursesArray = newCoursesArray
            //self.tableView.reloadData()
        }*/
    }
    
    
}
