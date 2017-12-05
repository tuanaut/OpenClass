//
//  StudentListViewController.swift
//  OpenClass
//
//  Created by Jacob Mann on 11/29/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit


class StudentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!;
    var currentCourse: Course!;
    var enrolledStudentCache = [User]();
    var enrollmentDateCache = [String]();
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return enrolledStudentCache.count;
    } // tableView
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableCell;
        
        print("currUser = ");
        let fullName = self.enrolledStudentCache[indexPath.row].GetFirstNameWithoutDatabaseAccess() + " " + self.enrolledStudentCache[indexPath.row].GetLastNameWithoutDatabaseAccess();
        print(fullName);
        
        cell.nameLabel.text = fullName;
        
        if (self.currentCourse.GetCreatorWithoutDatabaseAccess() != self.enrolledStudentCache[indexPath.row].GetAccountID())
        {
            // Item is student
            cell.enrollmentDateLabel.text = "Enrolled: " + self.currentCourse.GetEnrollmentDateWithoutDatabaseAccess(studentID: self.enrolledStudentCache[indexPath.row].GetAccountID());
        }
        else
        {
            // Item is creator of the course
            cell.enrollmentDateLabel.text = "Created Course: " + self.currentCourse.GetEnrollmentDateWithoutDatabaseAccess(studentID: self.enrolledStudentCache[indexPath.row].GetAccountID());
        }
        
        return cell
    } // tableView
    
    override func viewDidLoad()
    {
        super.viewDidLoad();

        tableView.delegate = self;
        tableView.dataSource = self;
        
        navigationController?.isNavigationBarHidden = false;
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = 100;
        
        // Change Navigation Icon
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Courses"), style: .plain, target: self, action: #selector(GoBack));
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero);
    } // viewDidLoad
    
    @objc func GoBack()
    {
        _ = navigationController?.popViewController(animated: true);
    } // GoBack

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    } // didReceiveMemoryWarning
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true);
        
        enrolledStudentCache.removeAll();
        tableView.reloadData();
        
        if (currentCourse != nil)
        {
            currentCourse.ReadAvailableData(completionHandler: {(success) -> Void in
                if (success)
                {
                    self.currentCourse.GetEnrolledStudents(completionHandler: {(success2) -> Void in
                        if (success2)
                        {
                            let enrolledStudentIDs = self.currentCourse.GetEnrolledStudentsWithoutDatabaseAccess();
                            
                            for studentID in enrolledStudentIDs
                            {
                                let nStudent = User(accountID: studentID);
                                nStudent.ReadAvailableData(completionHandler: {(success) -> Void in
                                    if (success)
                                    {
                                        self.enrolledStudentCache.append(nStudent);
                                        self.tableView.reloadData();
                                    }
                                });
                            }
                        }
                        
                        self.navigationController?.isNavigationBarHidden = false;
                    });
                }
            });
        }
    } // viewWillAppear
}
