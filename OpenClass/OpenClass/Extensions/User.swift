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
    private var EnrollmentDates:[String];
    
    public typealias CompletionHandler = (_ success:Bool) -> Void;
    
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
        EnrollmentDates = [String]();
    } // init
    
    init(snapshot: DataSnapshot)
    {
        let snapshotvalue = snapshot.value as? NSDictionary
        self.FirstName = snapshotvalue![FirstNameChild] as! String
        self.LastName = snapshotvalue![LastNameChild] as! String
        self.Email = snapshotvalue![EmailChild] as! String
        self.Password = ""
        self.AccountType = snapshotvalue![AccountTypeChild] as! String
        self.AccountID = snapshotvalue!["accountID"] as! String
        EnrolledCourses = [String]();
        EnrollmentDates = [String]();
    } // init
    
    init(accountID: String)
    {
        FirstName = "";
        LastName = "";
        Email = "";
        Password = "";
        AccountType = "";
        AccountID = accountID;
        EnrolledCourses = [String]();
        EnrollmentDates = [String]();
        self.ReadAvailableData();
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
        EnrollmentDates = [String]();
    } // init
    
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
    } // WriteAccount
    
    func WriteAllData(controller:RegisterViewController) -> Bool
    {
        if (WriteName(controller:controller) && WriteEmail(controller:controller) && WriteAccountType(controller:controller))
        {
            return true;
        }
        
        return false;
    } // WriteAllData
    
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
    } // WriteName
    
    func WriteEmail(controller:RegisterViewController) -> Bool
    {
        var result = false;
        
        if (!Email.isEmpty && !AccountID.isEmpty)
        {
            WriteData(data: [EmailChild:Email], controller:controller);
            result = true;
        }
        
        return result;
    } // WriteEmail
    
    func WriteAccountType(controller:RegisterViewController) -> Bool
    {
        var result = false;
        
        if (!AccountType.isEmpty && !AccountID.isEmpty)
        {
            WriteData(data: [AccountTypeChild:AccountType], controller:controller);
            result = true;
        }
        
        return result;
    } // WriteAccountType
    
    func UpdateEnrolled(enrolledCourse:String, controller:CreateCourseViewController) -> Void
    {
        let firebase = Database.database().reference(fromURL: FirebaseURL);
        let childRef = firebase.child(User_Root).child(AccountID).child(EnrolledChild);
        
        childRef.updateChildValues([enrolledCourse:String(describing: Date())], withCompletionBlock: {(err, ref) in
            if (err != nil)
            {
                controller.displayMyAlertMessage(userMessage: (err?.localizedDescription)!);
            }
            
            let enroller = Course(courseKey: enrolledCourse);
            enroller.UpdateEnrolled(student: self.AccountID);
            
            return;
        });
    } // UpdateEnrolled
    
    func UpdateEnrolled(enrolledCourse:String, controller:AddCourseViewController) -> Void
    {
        let firebase = Database.database().reference(fromURL: FirebaseURL);
        let childRef = firebase.child(User_Root).child(AccountID).child(EnrolledChild);
        
        childRef.updateChildValues([enrolledCourse:String(describing: Date())], withCompletionBlock: {(err, ref) in
            if (err != nil)
            {
                controller.displayMyAlertMessage(userMessage: (err?.localizedDescription)!, correct: false);
            }
            
            let enroller = Course(courseKey: enrolledCourse);
            enroller.UpdateEnrolled(student: self.AccountID);
            
            return;
        });
    } // UpdateEnrolled
    
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
    } // WriteData
    
    class func GetCurrentUser() -> User
    {
        let currUser = User();
        
        if (Auth.auth().currentUser?.uid != nil)
        {
            currUser.AccountID = (Auth.auth().currentUser?.uid)!;
            
            if (!currUser.AccountID.isEmpty)
            {
                currUser.ReadAvailableData();
            }
        }
        
        return currUser;
    } // GetCurrentUser
    
    func GetAccountType(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (AccountType.isEmpty)
        {
            // Attempt to retrieve Account Type from DB
            if (!AccountID.isEmpty)
            {
                Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    let dictionary = DataSnapshot.value as? [String: AnyObject];
                    self.AccountType = (dictionary![self.AccountTypeChild] as? String)!;
                    let flag = true;    // True if AccountType was successfully
                                        // retrieved, false otherwise
                    completionHandler(flag);
                });
            }
        }
    } // GetAccountType
    
    func GetAccountTypeWithoutDatabaseAccess() -> String
    {
        return self.AccountType;
    } // GetAccountTypeWithoutDatabaseAccess
    
    func GetEmail(completionHandler: @escaping CompletionHandler) -> Void
    {
        // Attempt to retrieve Account Type from DB
        if (!AccountID.isEmpty)
        {
            Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.Email = (dictionary![self.EmailChild] as? String)!;
                let flag = true;    // True if AccountType was successfully
                // retrieved, false otherwise
                completionHandler(flag);
            });
        }
    } // GetEmail
    
    func GetEmailWithoutDatabaseAccess() -> String
    {
        return self.Email;
    } // GetEmailWithoutDatabaseAccess
    
    func GetFirstName(completionHandler: @escaping CompletionHandler) -> Void
    {
        // Attempt to retrieve Account Type from DB
        if (!AccountID.isEmpty)
        {
            Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.FirstName = (dictionary![self.FirstNameChild] as? String)!;
                let flag = true;    // True if AccountType was successfully
                // retrieved, false otherwise
                completionHandler(flag);
            });
        }
    } // GetFirstName
    
    func GetFirstNameWithoutDatabaseAccess() -> String
    {
        return self.FirstName;
    } // GetFirstNameWithoutDatabaseAccess
    
    func GetLastName(completionHandler: @escaping CompletionHandler) -> Void
    {
        // Attempt to retrieve Account Type from DB
        if (!AccountID.isEmpty)
        {
            Database.database().reference().child(User_Root).child(AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                let dictionary = DataSnapshot.value as? [String: AnyObject];
                self.LastName = (dictionary![self.LastNameChild] as? String)!;
                let flag = true;    // True if AccountType was successfully
                // retrieved, false otherwise
                completionHandler(flag);
            });
        }
    } // GetLastName
    
    func GetLastNameWithoutDatabaseAccess() -> String
    {
        return self.LastName;
    } // GetLastNameWithoutDatabaseAccess
    
    func GetAccountID() -> String
    {
        return self.AccountID;
    } // GetAccountID
    
    func UserExists(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!AccountID.isEmpty)
        {
            Database.database().reference().child(User_Root).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                var exists = false;
                if (DataSnapshot.hasChild(self.AccountID))
                {
                    exists = true;
                }
                
                completionHandler(exists);
            });
        }
    } // UserExists
    
    func ReadAvailableData() -> Void
    {
        if (!AccountID.isEmpty)
        {
            self.UserExists(completionHandler: {(exists) -> Void in
                if (exists)
                {
                    Database.database().reference().child(self.User_Root).child(self.AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                        let dictionary = DataSnapshot.value as? [String: AnyObject];
                        self.LastName = (dictionary![self.LastNameChild] as? String)!;
                        self.FirstName = (dictionary![self.FirstNameChild] as? String)!;
                        self.Email = (dictionary![self.EmailChild] as? String)!;
                        self.AccountType = (dictionary![self.AccountTypeChild] as? String)!;
                    });
                }
            });
        }
    } // ReadAvailableData()
    
    func ReadAvailableData(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!AccountID.isEmpty)
        {
            self.UserExists(completionHandler: {(exists) -> Void in
                if (exists)
                {
                    Database.database().reference().child(self.User_Root).child(self.AccountID).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                        let dictionary = DataSnapshot.value as? [String: AnyObject];
                        self.LastName = (dictionary![self.LastNameChild] as? String)!;
                        self.FirstName = (dictionary![self.FirstNameChild] as? String)!;
                        self.Email = (dictionary![self.EmailChild] as? String)!;
                        self.AccountType = (dictionary![self.AccountTypeChild] as? String)!;
                        
                        completionHandler(true);
                    });
                }
            });
        }
    } // ReadAvailableData()
    
    func GetEnrolledCourses(controller:CourseFeedViewController) -> Void
    {
        if (!AccountID.isEmpty)
        {
            self.UserExists(completionHandler: {(exists) -> Void in
                if (exists)
                {
                    Database.database().reference().child(self.User_Root).child(self.AccountID).child(self.EnrolledChild).observeSingleEvent(of:
                        .value, with:
                        { (DataSnapshot) in
                            if (DataSnapshot.exists())
                            {
                                let array:NSArray = DataSnapshot.children.allObjects as NSArray;
                                
                                var courseArrayCount = 0;
                                for child in array
                                {
                                    courseArrayCount += 1;
                                    let snap = child as! DataSnapshot;
                                    self.EnrolledCourses.append(snap.key);
                                    self.EnrollmentDates.append(String(describing: snap.value));
                                    let newCourse = Course(courseKey: snap.key);
                                    controller.coursesArray.append(newCourse);
                                }
                                
                                controller.tableView.reloadData();
                            }
                    });
                }
            });
        }
    } // GetEnrolledCourses
    
    func GetEnrolledCourses(completionHandler: @escaping CompletionHandler) -> Void
    {
        if (!AccountID.isEmpty)
        {
            self.UserExists(completionHandler: {(exists) -> Void in
                if (exists)
                {
                    Database.database().reference().child(self.User_Root).child(self.AccountID).child(self.EnrolledChild).observeSingleEvent(of:
                        .value, with:
                        { (DataSnapshot) in
                            let flag = true;        // Array of enrolled courses successfully retrieved
                                                    // (even if that array is empty)
                            if (DataSnapshot.exists())
                            {
                                let array:NSArray = DataSnapshot.children.allObjects as NSArray;
                                
                                var courseArrayCount = 0;
                                for child in array
                                {
                                    courseArrayCount += 1;
                                    let snap = child as! DataSnapshot;
                                    self.EnrolledCourses.append(snap.key);
                                    self.EnrollmentDates.append(String(describing: snap.value));
                                }
                            }
                            
                            completionHandler(flag);
                    });
                }
            });
        }
    } // GetEnrolledCourses
    
    func GetEnrolledCoursesWithoutDatabaseAccess() -> [String]
    {
        return self.EnrolledCourses;
    } // GetEnrolledCourseWithoutDatabaseAccess
    
    func GetEnrollmentDateWithoutDatabaseAccess(courseKey: String) -> String
    {
        var result = "";
        
        if (self.EnrolledCourses.contains(courseKey))
        {
            let index = self.EnrolledCourses.index(of: courseKey);
            result = self.EnrollmentDates[index!];
        }
        
        return result;
    } // GetEnrollmentDateWithoutDatabaseAccess
}

