//
//  FullScreenPhotoViewController.swift
//  OpenClass
//
//  Created by Tuan Chau on 12/1/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit


class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var viewDrag: UIView!
    @IBOutlet weak var viewPinch: UIView!

    @IBOutlet weak var fullscreenphoto: UIImageView!
    //@IBOutlet weak var scrollView: UIScrollView!
    var passedimage: UIImage!
    var pinchGesture  = UIPinchGestureRecognizer()
    var panGesture  = UIPanGestureRecognizer()
    //var scrollImg: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullscreenphoto.image = passedimage
        fullscreenphoto.backgroundColor = .black
        fullscreenphoto.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        //scrollImg.minimumZoomScale = 1.0
        //scrollImg.maximumZoomScale = 10.0
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(FullScreenPhotoViewController.pinchedView))
        viewPinch.isUserInteractionEnabled = true
        viewPinch.addGestureRecognizer(pinchGesture)
        
       panGesture = UIPanGestureRecognizer(target: self, action: #selector(FullScreenPhotoViewController.draggedView(_:)))
        viewDrag.isUserInteractionEnabled = true
        viewDrag.addGestureRecognizer(panGesture)
    }
    
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        self.view.bringSubview(toFront: viewPinch)
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0

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

    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubview(toFront: viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
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
