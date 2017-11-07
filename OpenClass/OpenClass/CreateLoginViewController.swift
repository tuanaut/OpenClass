//
//  CreateLoginViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 10/29/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class CreateLoginViewController: UIViewController {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var accountTypeSegmentControl: UISegmentedControl!
    
    @IBAction func cancelCreateLogin(_ sender: Any) {
      //  self.removeAnimate()
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func submitCreateLogin(_ sender: Any) {
     //   self.removeAnimate()
        let userAccountType = String(accountTypeSegmentControl.selectedSegmentIndex)
        guard let userFirst = firstnameTextField.text,
              let userLast = lastnameTextField.text,
              let userEmail = emailTextField.text,
              let userPassword = passwordTextField.text,
              let userConfirmPass = confirmPasswordTextField.text
            else {
                displayMyAlertMessage(userMessage: "Form is not valid!")
                
                return;
            }
        
        // Check for empty fields
        if ((userFirst.isEmpty) || (userLast.isEmpty) || (userEmail.isEmpty) || (userPassword.isEmpty) || (userConfirmPass.isEmpty)) {
            
            // Display alert message
            displayMyAlertMessage(userMessage: "All fields are required");
            return;
        }
        
        // Check if passwords match
        if (userPassword != userConfirmPass) {
            displayMyAlertMessage(userMessage: "Passwords do not match");
            return;
        }
        
        // Authenticate and Store data
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: {(user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else { return}
            
            // Successfully authenticated user
            let ref = Database.database().reference(fromURL: "https://openclass-d7aa6.firebaseio.com/")
            let studentsReference = ref.child("students").child(uid)
            let professorsReference = ref.child("professors").child(uid)
            let values = ["firstname": userFirst, "lastname": userLast, "email": userEmail, "accounttype": userAccountType]
            // Store in students table
            if (self.accountTypeSegmentControl.selectedSegmentIndex == 0) {
                studentsReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    print("Saved user successfully into Firebase database")
                })
            // Store in professors table
            } else if (self.accountTypeSegmentControl.selectedSegmentIndex == 1) {
                professorsReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    print("Saved user successfully into Firebase database")
                })
            }
        })
        
        // Display alert with confirmation.
        let myAlert = UIAlertController(title:"Alert", message: "Registration is successful!", preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)});
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 205, g: 35, b: 35)
//        createLoginView.backgroundColor = UIColor(r: 205, g: 35, b: 35)
//        createLoginView.translatesAutoresizingMaskIntoConstraints = false
//        createLoginView.layer.cornerRadius = 5
//        createLoginView.layer.masksToBounds = true; self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        self.showAnimate()
        // Do any additional setup after loading the view.
       
//        let ref = Database.database().reference(fromURL: "https://openclass-d7aa6.firebaseio.com/")
//        ref.updateChildValues([])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

