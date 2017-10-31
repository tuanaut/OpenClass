//
//  ViewController.swift
//  OpenClass
//
//  Created by Jerry Chiu on 10/29/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputContainer: UIView!
    @IBAction func showCreateLogin(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createLoginID") as! CreateLoginViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 205, g: 35, b: 35)
        inputContainer.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.layer.cornerRadius = 5
        inputContainer.layer.masksToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

