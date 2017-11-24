//
//  Course.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/15/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit


class Course
{
    private var Name:         String
    private var Description:  String
    private var Key:          String
    private var Creator:      String
    
    // Constants
    private let FirebaseURL         = "https://openclass-d7aa6.firebaseio.com/";
    private let Course_Root         = "courses";
    private let NameChild           = "name";
    private let DescriptionChild    = "description";
    private let KeyChild            = "key";
    private let CreatorChild        = "creator";
    private let CourseKeyLength     = 5;
    
    init (courseKey: String)
    {
        self.Key = courseKey;
        self.Name = "";
        self.Description = "";
        self.Creator = "";
        self.ReadAvailableData();
    }
    
    init(courseName: String, courseDescription: String, courseCreator: String)
    {
        self.Name = courseName;
        self.Description = courseDescription;
        self.Key = Course.GenerateCourseKey(length: CourseKeyLength);
        self.Creator = courseCreator;
    }
    
    init(snapshot: DataSnapshot)
    {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.Name = snapshotvalue!["CourseName"] as! String
        self.Description = snapshotvalue!["CourseDescription"] as! String
        self.Key = snapshotvalue!["CourseKey"] as! String
        self.Creator = snapshotvalue!["CourseCreator"] as! String
    }
    
    init ()
    {
        Name = "";
        Description = "";
        Key = "";
        Creator = "";
    }
    
    func WriteCourse(controller:CreateCourseViewController) -> Bool
    {
        var result = false;
        
        if (!Name.isEmpty && !Creator.isEmpty)
        {
            if (Key.isEmpty)
            {
                Key = Course.GenerateCourseKey(length: CourseKeyLength);
            }
            
            // Write data
            WriteData(data: [NameChild:Name], controller:controller);
            WriteData(data: [CreatorChild:Creator], controller:controller);
            if (!Description.isEmpty)
            {
                WriteData(data: [DescriptionChild:Description], controller:controller);
                result = true;
            }
            else
            {
                result = true;
            }
            
            if (result)
            {
                // Display alert with confirmation.
                let myAlert = UIAlertController(title:"Alert", message: "Course Was Created!", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in controller.dismiss(animated: true, completion: nil)});
                
                myAlert.addAction(okAction);
                controller.present(myAlert, animated: true, completion: nil);
            }
        }
        
        return result;
    }
    
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
    }
    
    func GetName() -> String
    {
        if (Name.isEmpty)
        {
            // Attempt to retrieve Name from DB
            if (!Key.isEmpty)
            {
                Database.database().reference().child(Course_Root).child(Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.Name = (dictionary![self.NameChild] as? String)!;
                });
            }
        }
        
        return self.Name;
    }
    
    func GetDescription() -> String
    {
        if (Description.isEmpty)
        {
            // Attempt to retrieve Name from DB
            if (!Key.isEmpty)
            {
                Database.database().reference().child(Course_Root).child(Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.Description = (dictionary![self.DescriptionChild] as? String)!;
                });
            }
        }
        
        return self.Description;
    }
    
    func GetKey() -> String
    {
        return self.Key;
    }
    
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
    }
    
    func ReadAvailableData() -> Void
    {
        if (!Key.isEmpty)
        {
            Database.database().reference().child(Course_Root).child(Key).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.Name = (dictionary![self.NameChild] as? String)!;
                self.Description = (dictionary![self.DescriptionChild] as? String)!;
                self.Creator = (dictionary![self.CreatorChild] as? String)!;
            });
        }
    }
}

