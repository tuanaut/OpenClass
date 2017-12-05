//
//  Course.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit


class Course
{
    private var Name:               String;
    private var Description:        String;
    private var Key:                String;
    private var Creator:            String;
    private var EnrolledStudents:   [String];
    private var EnrollmentDates:    [String];
    
    public typealias CompletionHandler = (_ success:Bool) -> Void;
    
    // Constants
    private let FirebaseURL         = "https://openclass-d7aa6.firebaseio.com/";
    private let Course_Root         = "courses";
    private let User_Root           = "users";
    private let NameChild           = "name";
    private let DescriptionChild    = "description";
    private let KeyChild            = "key";
    private let CreatorChild        = "creator";
    private let CourseKeyLength     = 5;
    private let EnrolledChild       = "enrolled";
    
    init (courseKey: String)
    {
        self.Key = courseKey;
        self.Name = "";
        self.Description = "";
        self.Creator = "";
        self.EnrolledStudents = [String]();
        self.EnrollmentDates = [String]();
        self.ReadAvailableData();
    } // init
    
    init(courseName: String, courseDescription: String, courseCreator: String)
    {
        self.Name = courseName;
        self.Description = courseDescription;
        self.Key = Course.GenerateCourseKey(length: CourseKeyLength);
        self.Creator = courseCreator;
        self.EnrolledStudents = [String]();
        self.EnrollmentDates = [String]();
    } // init
    
    init(snapshot: DataSnapshot)
    {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.Name = snapshotvalue!["CourseName"] as! String
        self.Description = snapshotvalue!["CourseDescription"] as! String
        self.Key = snapshotvalue!["CourseKey"] as! String
        self.Creator = snapshotvalue!["CourseCreator"] as! String
        self.EnrolledStudents = [String]();
        self.EnrollmentDates = [String]();
    } // init
    
    init ()
    {
        Name = "";
        Description = "";
        Key = "";
        Creator = "";
        self.EnrolledStudents = [String]();
        self.EnrollmentDates = [String]();
    } // init
    
    func WriteCourse(controller:CreateCourseViewController, completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!Name.isEmpty && !Creator.isEmpty)
        {
            if (Key.isEmpty)
            {
                Key = Course.GenerateCourseKey(length: CourseKeyLength);
            }
            
            // Check if course key already exists
            Database.database().reference().child(Course_Root).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                while (DataSnapshot.hasChild(self.Key))
                {
                    self.Key = Course.GenerateCourseKey(length:self.CourseKeyLength);
                }
                
                // Valid key is available
                // Write data
                self.WriteData(data: [self.NameChild:self.Name], controller:controller);
                self.WriteData(data: [self.CreatorChild:self.Creator], controller:controller);
                if (!self.Description.isEmpty)
                {
                    self.WriteData(data: [self.DescriptionChild:self.Description], controller:controller);
                }
                
                // Display alert with confirmation.
                let myAlert = UIAlertController(title:"Alert", message: "Course Was Created!", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in controller.dismiss(animated: true, completion: nil)});
                
                myAlert.addAction(okAction);
                controller.present(myAlert, animated: true, completion: nil);
                
                let result = true;
                completionHandler(result);
            });
        }
    } // WriteCourse
    
    private func WriteData(data:[String:String], controller:CreateCourseViewController) -> Void
    {
        let firebase = Database.database().reference(fromURL: FirebaseURL);
        let childRef = firebase.child(Course_Root).child(Key);
        
        childRef.updateChildValues(data, withCompletionBlock: {(err, ref) in
            if (err != nil)
            {
                controller.displayMyAlertMessage(userMessage: (err?.localizedDescription)! );
            }
            return;
        });
    } // WriteData
    
    func GetNameAndUpdateCell(cell:CourseFeedTableViewCell) -> Void
    {
        // Attempt to retrieve Name from DB
        if (!Key.isEmpty)
        {
            Database.database().reference().child(Course_Root).child(Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.Name = (dictionary![self.NameChild] as? String)!;
                
                cell.CourseNumberLabel.text = self.Name;
            });
        }
    } // GetNameAndUpdateCell
    
    func GetDescriptionAndUpdateCell(cell:CourseFeedTableViewCell) -> Void
    {
        // Attempt to retrieve Name from DB
        if (!Key.isEmpty)
        {
            Database.database().reference().child(Course_Root).child(Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.Description = (dictionary![self.DescriptionChild] as? String)!;
                
                cell.CourseNameLabel.text = self.Description;
            });
        }
    } // GetDescriptionAndUpdateCell
    
    func GetKey() -> String
    {
        return self.Key;
    } // GetKey
    
    // function to generate random string for the course key
    private static func GenerateCourseKey(length: Int) -> String
    {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        let len = UInt32(letters.length);
        
        var randomString = "";
        
        for _ in 0 ..< length
        {
            let rand = arc4random_uniform(len);
            var nextChar = letters.character(at: Int(rand));
            randomString += NSString(characters: &nextChar, length: 1) as String;
        }
        return randomString;
    } // GenerateCourseKey
    
    func ReadAvailableData() -> Void
    {
        if (!Key.isEmpty)
        {
            var keyIsAvailable = false;
            
            self.CourseIsAvailable(completionHandler: {(available) -> Void in
                if (available)
                {
                    keyIsAvailable = true;
                }
            });
            
            if (keyIsAvailable)
            {
                Database.database().reference().child(Course_Root).child(Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    
                    self.Name = (dictionary![self.NameChild] as? String)!;
                    self.Description = (dictionary![self.DescriptionChild] as? String)!;
                    self.Creator = (dictionary![self.CreatorChild] as? String)!;
                });
            }
        }
    } // ReadAvailableData
    
    func ReadAvailableData(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!Key.isEmpty)
        {
            self.CourseIsAvailable(completionHandler: {(available) -> Void in
                if (available)
                {
                    Database.database().reference().child(self.Course_Root).child(self.Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                        let dictionary = DataSnapshot.value as? [String: AnyObject];
                        
                        self.Name = (dictionary![self.NameChild] as? String)!;
                        self.Description = (dictionary![self.DescriptionChild] as? String)!;
                        self.Creator = (dictionary![self.CreatorChild] as? String)!;
                        
                        completionHandler(true);
                    });
                }
            });
        }
    } // ReadAvailableData
    
    func CourseIsAvailable(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!Key.isEmpty)
        {
            Database.database().reference().child(Course_Root).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                var flag = false;
                
                if (DataSnapshot.hasChild(self.Key))
                {
                    flag = true;
                }
                
                completionHandler(flag);
            });
        }
    } // CourseIsAvailable
    
    func UpdateEnrolled(student: String)
    {
        if (!Key.isEmpty && !student.isEmpty)
        {
            let firebase = Database.database().reference(fromURL: FirebaseURL);
            let childRef = firebase.child(Course_Root).child(Key).child(EnrolledChild);
            childRef.updateChildValues([student:String(describing: Date())], withCompletionBlock: {(err, ref) in
                if (err != nil)
                {
                    print("err != nil");
                }
                else
                {
                    print("err == nil");
                }
                return;
            });
        }
    }
    
    func GetEnrolledStudents(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!Key.isEmpty)
        {
            Database.database().reference().child(Course_Root).child(Key).child(EnrolledChild).observeSingleEvent(of: .value, with: {(snapshot) in
                if (snapshot.exists())
                {
                    let result = true;
                    let array:NSArray = snapshot.children.allObjects as NSArray;
                    
                    var enrolledStudentCount = 0;
                    for student in array
                    {
                        enrolledStudentCount += 1;
                        let snap = student as! DataSnapshot;
                        self.EnrolledStudents.append(snap.key);
                        self.EnrollmentDates.append(snap.value as! String);
                    }
                    
                    completionHandler(result);
                }
            });
        }
    } // GetEnrolledStudents
    
    func GetEnrolledStudentsWithoutDatabaseAccess() -> [String]
    {
        return self.EnrolledStudents;
    }
    
    func GetEnrollmentDateWithoutDatabaseAccess(studentID: String) -> String
    {
        var result = "";
        
        if (self.EnrolledStudents.contains(studentID))
        {
            let index = self.EnrolledStudents.index(of: studentID);
            result = self.EnrollmentDates[index!];
        }
        
        return result;
    } // GetEnrollmentDateWithoutDatabaseAccess
    
    func GetCreatorWithoutDatabaseAccess() -> String
    {
        return self.Creator;
    }
}

