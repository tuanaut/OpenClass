//
//  SelectedNotesViewController.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/21/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SelectedNotesViewController: UIViewController
{
    
   
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var passedNotesID: String!
    var passedUsername: String!
    var passedCourseKey: String!
   // @IBOutlet weak var notesDescriptionText: UITextView!
    // @IBOutlet weak var notesDescriptionText: UITextField!
    //@IBOutlet weak var notesSubjectText: UITextField!

    @IBOutlet weak var notesSubjectText: UILabel!
    @IBOutlet weak var notesDescriptionText: UILabel!
    @IBOutlet weak var notesImage: UIImageView!
    
    
    
    var databaseRef: DatabaseReference!
    {
        return Database.database().reference()
    }
    
    var storageRef: Storage!
    {
        return Storage.storage()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("this is passed notes id")
        print(passedNotesID)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Notes Feed"), style: .plain, target: self, action: #selector(GoBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Comments"), style: .plain, target: self, action: #selector(self.gotoCommentsSection))
       fetchInfo()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        //fetchInfo()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchInfo()
    {
        activityIndicator.center = CGPoint(x: self.notesImage.frame.maxX/2, y: self.notesImage.frame.minY + self.notesImage.frame.maxX/2);
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        let query = databaseRef.child("notes").child(passedCourseKey).queryOrdered(byChild: "NotesID").queryEqual(toValue: passedNotesID)
        query.observeSingleEvent(of: .value, with: {(notes) in
            var currentNotes: Notes
            print("snapshots of notes")
            print(notes)
            for note in notes.children
            {
                 currentNotes = Notes(snapshot: note as! DataSnapshot)
                
                self.notesSubjectText.text = currentNotes.notesSubject
                self.notesDescriptionText.text = currentNotes.notesDescription
                self.navigationItem.title = self.notesSubjectText.text!
                
                self.storageRef.reference(forURL: currentNotes.notesImageURL).getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                    if error == nil
                    {
                        self.notesImage.image = UIImage(data: data!)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    else
                    {
                        print(error!.localizedDescription)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                    }
                });
            }
        });
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {
        
        if(notesImage.image != nil){
        
            performSegue(withIdentifier: "GoToFullScreenPhoto", sender: self)
        }

    }
    
    @objc func GoBack()
    {
        _ = navigationController?.popViewController(animated: true);
    }
    
    @objc func gotoCommentsSection()
    {
        performSegue(withIdentifier: "GoToComments", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "GoToComments")
        {
            let viewController = segue.destination as! CommentsViewController
            viewController.passedNotesID = passedNotesID

            viewController.passedCourseKey = passedCourseKey
        }
        else if(segue.identifier == "GoToFullScreenPhoto")
        {
            let viewController = segue.destination as! FullScreenPhotoViewController
            viewController.passedimage = self.notesImage.image
            
        }
    }
}

