//
//  Users.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/13/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import Foundation
import Firebase

class User
{
    private var FirstName:      String;
    private var LastName:       String;
    private var Email:          String;
    private var Password:       String;
    private var AccountType:    String;
    private var AccountID:      String;
    private var EnrolledCourses:[String];
    
    // Constants
    private let FirebaseURL         = "https://openclass-d7aa6.firebaseio.com/";
    private let User_Root           = "users";
    private let FirstNameChild      = "firstName";
    private let LastNameChild       = "lastName";
    private let EmailChild          = "email";
    private let AccountTypeChild    = "accountType";
    private let EnrolledChild       = "enrolled"
    
    init(firstName: String, lastName: String, email: String, password: String, accountType: String)
    {
        self.FirstName = firstName
        self.LastName = lastName
        self.Email = email
        self.Password = password
        self.AccountType = accountType
        self.AccountID = ""
        EnrolledCourses = [String]();
    }
    
    init(snapshot: DataSnapshot)
    {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.FirstName = snapshotvalue![FirstNameChild] as! String
        self.LastName = snapshotvalue![LastNameChild] as! String
        self.Email = snapshotvalue![EmailChild] as! String
        self.Password = snapshotvalue!["password"] as! String
        self.AccountType = snapshotvalue![AccountTypeChild] as! String
        self.AccountID = snapshotvalue!["accountID"] as! String
        EnrolledCourses = [String]();
    }
    
    init()
    {
        FirstName = "";
        LastName = "";
        Email = "";
        Password = "";
        AccountType = "";
        AccountID = "";
        EnrolledCourses = [String]();
    }
    
    func WriteAccount(controller:RegisterViewController) -> Bool
    {
        if (!Email.isEmpty && !AccountType.isEmpty && !Password.isEmpty)
        {
            Auth.auth().createUser(withEmail: Email, password: Password, completion: {(user, error) in
                if (error != nil)
                {
                    controller.displayMyAlertMessage(userMessage: (error?.localizedDescription)! );
                    return;
                }
                
                guard (user?.uid) != nil else { return; }
                
                // Set the Account ID
                self.AccountID = (user?.uid)!;
                
                // Successfully authenticated user
                // Store user data in database
                if (self.WriteAllData(controller:controller))
                {
                    // Display alert with confirmation.
                    let myAlert = UIAlertController(title:"Success!", message: "Registration was successful!", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in controller.dismiss(animated: true, completion: nil)});
                    
                    myAlert.addAction(okAction);
                    controller.present(myAlert, animated: true, completion: nil);
                    
                    print("Saved user successfully into Firebase database")
                }
            });
        }
        return false;
    }
    
    func WriteAllData(controller:RegisterViewController) -> Bool
    {
        if (WriteName(controller:controller) && WriteEmail(controller:controller) && WriteAccountType(controller:controller))
        {
            return true;
        }
        
        return false;
    }
    
    func WriteName(controller:RegisterViewController) -> Bool
    {
        var result = false;
        
        if (!FirstName.isEmpty && !LastName.isEmpty && !AccountID.isEmpty)
        {
            self.WriteData(data: [FirstNameChild:FirstName], controller:controller);
            self.WriteData(data: [LastNameChild:LastName], controller:controller);
            result = true;
        }
        
        return result;
    }
    
    func WriteEmail(controller:RegisterViewController) -> Bool
    {
        var result = false;
        
        if (!Email.isEmpty && !AccountID.isEmpty)
        {
            WriteData(data: [EmailChild:Email], controller:controller);
            result = true;
        }
        
        return result;
    }
    
    func WriteAccountType(controller:RegisterViewController) -> Bool
    {
        var result = false;
        
        if (!AccountType.isEmpty && !AccountID.isEmpty)
        {
            WriteData(data: [AccountTypeChild:AccountType], controller:controller);
            result = true;
        }
        
        return result;
    }
    
    func UpdateEnrolled(enrolledCourse:String, controller:CreateCourseViewController) -> Void
    {
        let firebase = Database.database().reference(fromURL: FirebaseURL);
        let childRef = firebase.child(User_Root).child(AccountID).child(EnrolledChild);
        
        childRef.updateChildValues([enrolledCourse:""], withCompletionBlock: {(err, ref) in
            if (err != nil)
            {
                controller.displayMyAlertMessage(userMessage: (err?.localizedDescription)!);
            }
            return;
        });
    }
    
    private func WriteData(data:[String:String], controller:RegisterViewController) -> Void
    {
        let firebase = Database.database().reference(fromURL: FirebaseURL);
        let childRef = firebase.child(User_Root).child(AccountID);
        childRef.updateChildValues(data, withCompletionBlock: {(err, ref) in
            if (err != nil)
            {
                controller.displayMyAlertMessage(userMessage: (err?.localizedDescription)!);
            }
            return;
        });
    }
    
    class func GetCurrentUser() -> User
    {
        let currUser = User();
        currUser.AccountID = (Auth.auth().currentUser?.uid)!;
        
        if (!currUser.AccountID.isEmpty)
        {
            currUser.ReadAvailableData();
        }
        
        return currUser;
    }
    
    func GetAccountType() -> String
    {
        if (AccountType.isEmpty)
        {
            // Attempt to retrieve Account Type from DB
            if (!AccountID.isEmpty)
            {
                Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.AccountType = (dictionary![self.AccountTypeChild] as? String)!;
                });
            }
        }
        
        return self.AccountType;
    }
    
    func GetEmail() -> String
    {
        if (Email.isEmpty)
        {
            // Attempt to retrieve Email from DB
            if (!AccountID.isEmpty)
            {
                Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.Email = (dictionary![self.EmailChild] as? String)!;
                });
            }
        }
        
        return self.Email;
    }
    
    func GetFirstName() -> String
    {
        if (FirstName.isEmpty)
        {
            // Attempt to retrieve Email from DB
            if (!AccountID.isEmpty)
            {
                Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.FirstName = (dictionary![self.FirstNameChild] as? String)!;
                });
            }
        }
        
        return self.FirstName;
    }
    
    func GetLastName() -> String
    {
        if (LastName.isEmpty)
        {
            // Attempt to retrieve Email from DB
            if (!AccountID.isEmpty)
            {
                Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.LastName = (dictionary![self.LastNameChild] as? String)!;
                });
            }
        }
        
        return self.LastName;
    }
    
    func GetAccountID() -> String
    {
        return self.AccountID;
    }
    
    func ReadAvailableData() -> Void
    {
        if (!AccountID.isEmpty)
        {
            Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.LastName = (dictionary![self.LastNameChild] as? String)!;
                self.FirstName = (dictionary![self.FirstNameChild] as? String)!;
                self.Email = (dictionary![self.EmailChild] as? String)!;
                self.AccountType = (dictionary![self.AccountTypeChild] as? String)!;
            });
        }
    }
    
    func GetEnrolledCourses() -> [String]
    {
        if (EnrolledCourses.isEmpty)
        {
            if (!AccountID.isEmpty)
            {
                Database.database().reference().child(User_Root).child(AccountID).child(EnrolledChild).observeSingleEvent(of:
                    .value, with:
                    { (DataSnapshot) in
                        if (DataSnapshot.exists())
                        {
                            let array:NSArray = DataSnapshot.children.allObjects as NSArray;
                            
                            for child in array
                            {
                                let snap = child as! DataSnapshot;
                                if (snap.value is NSDictionary)
                                {
                                    self.EnrolledCourses.append(snap.key);
                                }
                            }
                        }
                });
            }
        }
        
        return self.EnrolledCourses;
    }
}

