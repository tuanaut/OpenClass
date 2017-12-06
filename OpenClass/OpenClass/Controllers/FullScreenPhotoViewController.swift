//
//  FullScreenPhotoViewController.swift
//  OpenClass
//
//  Created by Tuan Chau on 12/1/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var fullscreenphoto: UIImageView!
    
    var passedimage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullscreenphoto.image = passedimage
        fullscreenphoto.backgroundColor = .black
        fullscreenphoto.clipsToBounds = true
               // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.hidesBarsOnTap = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   /* @IBAction func tappedImage(_ sender: Any) {
        navigationController?.isNavigationBarHidden = !(navigationController?.isNavigationBarHidden)!
        
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
