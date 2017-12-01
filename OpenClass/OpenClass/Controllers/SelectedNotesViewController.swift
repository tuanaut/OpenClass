//
//  SelectedNotesViewController.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/21/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SelectedNotesViewController: UIViewController
{
    
   
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Comments", style: .plain, target: self, action: #selector(self.gotoCommentsSection))
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        fetchInfo()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchInfo()
    {
       
          
        
        
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
                self.storageRef.reference(forURL: currentNotes.notesImageURL).getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                    if error == nil
                    {
                        self.notesImage.image = UIImage(data: data!)
                        
                        
                    }
                    else
                    {
                        print(error!.localizedDescription)
                    }
                });
            }
        });
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
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
    }
}

