//
//  ForgotPasswordViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/17/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let userEmail = emailTextField.text
        
        Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: {(error)
            in
            if (error != nil)
            {
                self.displayMyAlertMessage(userMessage: (error?.localizedDescription)!)
                
                return
            }
            else
            {
                let myAlert = UIAlertController(title:"Alert", message: "Please check your email to confirm the password reset", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)});
                
                myAlert.addAction(okAction);
                self.present(myAlert, animated: true, completion: nil);
                
                print("Sent password reset to email successfully.")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }

}
