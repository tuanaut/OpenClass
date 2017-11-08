//
//  CourseFeedViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/6/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase

class CourseFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleLogout()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let logoutError
        {
            print(logoutError)
        }
        
        // Successfully logged out
        _ = navigationController?.popToRootViewController(animated: true)
    }

}
