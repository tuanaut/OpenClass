//
//  CreateLoginViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 10/29/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController
{
    @IBOutlet weak var firstnameTextField: UITextField!;
    @IBOutlet weak var lastnameTextField: UITextField!;
    @IBOutlet weak var emailTextField: UITextField!;
    @IBOutlet weak var passwordTextField: UITextField!;
    @IBOutlet weak var confirmPasswordTextField: UITextField!;
    @IBOutlet weak var accountTypeSegmentControl: UISegmentedControl!;
    @IBOutlet weak var ScrollView: UIScrollView!;
    
    var ScrollViewConstraint: NSLayoutConstraint?;

    @IBAction func cancelCreateLogin(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func submitCreateLogin(_ sender: Any)
    {
        // Check for empty fields
        if ((firstnameTextField.text!.isEmpty) || (lastnameTextField.text!.isEmpty) || (emailTextField.text!.isEmpty) || (passwordTextField.text!.isEmpty) || (confirmPasswordTextField.text?.isEmpty)!)
        {
            // Display alert message
            displayMyAlertMessage(userMessage: "All fields must be filled out to create an account");
            return;
        }
        
        // Check if passwords match
        if (passwordTextField.text! != confirmPasswordTextField.text!)
        {
            displayMyAlertMessage(userMessage: "Passwords do not match");
            return;
        }
        
        // Store user data into an object
        let loginUser = User(firstName: firstnameTextField.text!, lastName: lastnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, accountType: String(accountTypeSegmentControl.selectedSegmentIndex));
        
        // Authenticate and Store data
        loginUser.WriteAccount(controller: self);
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();

        // Initial UI setup
        //view.backgroundColor = UIColor(r: 205, g: 35, b: 35)
        navigationController?.isNavigationBarHidden = true;
        
        // Dismiss keyboard when touching anywhere within the view
        self.hideKeyboardWhenTappedAround();
        
        // Set up keyboard showing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil);
        
        // Set up keyboard dismissing listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil);
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated);
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    /** This part will be used for the create course page because it looks cooler
     
    func showAnimate()
    {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
    }
 */
    
    // Handles how the textfields should appear when keyboard is showing
    @objc func handleKeyboardNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            // Get the x, y, width, height of keyboard
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue;
            
            // Determine if keyboard is showing or not
            let isKeyboardShowing = (notification.name == NSNotification.Name.UIKeyboardWillShow);
            
            // Adjust the constraints if keyboard is showing or dismissing
            var contentInset:UIEdgeInsets = self.ScrollView.contentInset;
            contentInset.bottom = keyboardFrame.height;
            ScrollView.contentInset = isKeyboardShowing ? contentInset : UIEdgeInsets.zero;
                        
            // Smooth transition of textfield going up and down
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded();
                
                }, completion: {(completed) in
            });
        }
    }
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
}

