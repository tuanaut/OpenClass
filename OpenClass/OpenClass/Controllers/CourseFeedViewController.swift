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
    
    
    var courseList: [Courses] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

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
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enroll", style: .plain, target: self, action: #selector(enrollCourse))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(AddCourse))
        checkIfUserIsLoggedIn()
    }
    
    @objc func AddCourse() {
        //let newMessageController = AddCourseViewController()
        //present(newMessageController, animated: true, completion: nil)
        
        let uid = Auth.auth().currentUser?.uid
       //var test = Auth.auth().currentUser?.value(forKeyPath: "accounttype")
        //print (test!)
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
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            handleLogout()
        }
        else{
            //let uid = Auth.auth().currentUser?.uid
            
            print("HII");
            
            
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
        return courseList.count
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
            courseList.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let course = courseList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseFeedTableViewCell") as! CourseFeedTableViewCell
        
//        if (cell == nil)
//        {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "CourseFeedTableViewCell")
//        }
        
//        course!.textLabel?.text = courseList[indexPath.row]
//        course?.textLabel?.textAlignment = .center
//        course?.textLabel?.numberOfLines = 0
        
        cell.setCourse(course: course)
        
        return cell
    }
    
}
