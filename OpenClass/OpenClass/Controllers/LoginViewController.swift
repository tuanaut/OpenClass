//
//  ViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 10/29/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var EmailEdit: UITextField!
    @IBOutlet weak var PasswordEdit: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBAction func LoginButton(_ sender: Any)
    {
        handleLogin()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Initial UI setup
        navigationController?.isNavigationBarHidden = true
        //self.view.backgroundColor = UIColor(r: 205, g: 35, b: 35)
        inputContainer.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.layer.cornerRadius = 5
        inputContainer.layer.masksToBounds = true
        
        // Hide keyboard when tapped within the view
        self.hideKeyboardWhenTappedAround()
        
        // User is already logged in
        if (Auth.auth().currentUser?.uid != nil)
        {
            performSegue(withIdentifier: "LoggedIn", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ErrorLabel.text = nil
        EmailEdit.text = nil
        PasswordEdit.text = nil
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLogin()
    {
        guard let email = EmailEdit.text,
              let password = PasswordEdit.text
        else
        {
            print("Form is not valid")
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            
            if (error != nil) {
                self.ErrorLabel.text = "Invalid email or password. Please try again."
                print(error!)
                return
            }
            
            // Successfully logged in
            self.performSegue(withIdentifier: "LoggedIn", sender: self)
        })
    }
}

