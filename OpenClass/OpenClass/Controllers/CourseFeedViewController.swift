//
//  CourseFeedViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/6/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class CourseFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var userCourses: [String] = []
    var coursesArray = [Course]()
    
    override func viewDidLoad()
    {
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
        getRightNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true);
        
        // Reset course array to empty every time you go back to this view controller and reload table view
        coursesArray.removeAll();
        tableView.reloadData();
        checkIfUserIsLoggedIn();
        
        navigationController?.isNavigationBarHidden = false;
    }
    
    @objc func AddCourse()
    {
        let currentUser = User.GetCurrentUser();
        let accountType = currentUser.GetAccountType();
        
        if (accountType == "0")
        {
            self.performSegue(withIdentifier: "GoToAddCourse", sender: self);
        }
        else
        {
            self.performSegue(withIdentifier: "GoToCreateCourse", sender: self);
        }
    }
    
    @objc func handleLogout()
    {
        do
        {
            try Auth.auth().signOut();
        }
        catch let logoutError
        {
            print(logoutError);
        }
        
        // Successfully logged out
        _ = navigationController?.popToRootViewController(animated: true);
    }

//================== TableView cell functions ==================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return coursesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
   
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "Drop Crouse"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:IndexPath)
    {
        if (editingStyle == .delete)
        {
            coursesArray.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
            as! CourseFeedTableViewCell;
        cell.CourseNumberLabel.text = coursesArray[indexPath.row].GetName();
        cell.CourseNameLabel.text = coursesArray[indexPath.row].GetDescription();
        return cell;
    }
//======================================================

    // Get the user's enrolled courses
    private func fetchCourses()
    {
        let currentUser = User.GetCurrentUser();
        
        let enrolledCourses = currentUser.GetEnrolledCourses();
        
        for course in enrolledCourses
        {
            let newCourse = Course(courseKey: course);
            self.coursesArray.append(newCourse)
        }
        
        self.tableView.reloadData();
    }
    
    // Checks if user is logged in, to determine to logout or get user data
    func checkIfUserIsLoggedIn()
    {
        if Auth.auth().currentUser?.uid == nil
        {
            handleLogout()
        }
        else
        {
            fetchCourses()
            tableView.reloadData()
        }
    }
    
    // Checks if it is student or professor and adjusts the right navigation button accordingly
    func getRightNavigationButton()
    {
        let currentUser = User.GetCurrentUser();
        let acctType = currentUser.GetAccountType();
        
        if ( acctType == "0")
        {
            self.title = "Enrolled Courses";
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enroll", style: .plain, target: self, action: #selector(self.AddCourse));
        }
        else
        {
            self.title = "Created Courses";
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.AddCourse));
        }
    }
}
