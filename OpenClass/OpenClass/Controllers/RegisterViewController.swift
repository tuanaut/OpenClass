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
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var accountTypeSegmentControl: UISegmentedControl!
    
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
        super.viewDidLoad()

        // Initial UI setup
        //view.backgroundColor = UIColor(r: 205, g: 35, b: 35)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }    
    
}



