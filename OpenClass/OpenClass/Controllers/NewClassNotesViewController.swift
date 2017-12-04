//
//  NewClassNotesViewController.swift
//  OpenClassUITests
//
//  Created by Tuan Chau on 11/17/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class NewClassNotesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var NotesSubjectText: UITextField!
    var passedkey: String!
    @IBOutlet weak var NotesDescriptionText: UITextField!
    
   // @IBOutlet weak var NotesDescriptionText: UITextField!
    //let pickerController = UIImagePickerController()
    
    @IBOutlet weak var NotesImage: UIImageView!
    {
        didSet
        {
            NotesImage.layer.cornerRadius = 5
        }
    }
    
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
        
        // Hide keyboard when tapped with in the view
        self.hideKeyboardWhenTappedAround()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(PostNotes))
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImage(_ sender: Any)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose Photo", message: "From Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion:nil)            }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion:nil)
            imagePickerController.allowsEditing = false
            }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        NotesImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func PostNotes()
    {
        let notesID = NSUUID().uuidString
        let imageName = NSUUID().uuidString
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        if(NotesImage.image == nil || (NotesSubjectText.text?.isEmpty)! || (NotesDescriptionText.text?.isEmpty)!)
        {
            displayMyAlertMessage(userMessage: "All fields are required", correct: false)
            return
        }
        
        else{
        let imageData = UIImageJPEGRepresentation(NotesImage.image!, 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        //let uid = Auth.auth().currentUser?.uid
        
        let imagePath = "notesImage\(imageName)/notesPic.jpg"
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.alpha = 0.75
        UIApplication.shared.beginIgnoringInteractionEvents()
        let imageRef = storageRef.reference().child(imagePath)
        imageRef.putData(imageData!, metadata: metaData, completion: {(newMetaData, error) in
            if (error == nil)
            {
                let currentUser = User.GetCurrentUser();
                currentUser.ReadAvailableData(completionHandler: {(success) -> Void in
                    let firstName = currentUser.GetFirstNameWithoutDatabaseAccess();
                    let lastName = currentUser.GetLastNameWithoutDatabaseAccess();
                    
                    let newNotes = Notes(notesSubject: self.NotesSubjectText.text!, notesDescription: self.NotesDescriptionText.text!, notesImageURL: String(describing: newMetaData!.downloadURL()!), firstName: firstName, lastName: lastName, notesID: notesID, key: self.passedkey)
                    
                    
                  
                        let notesRef = Database.database().reference().child("notes").child(self.passedkey).childByAutoId()
                        
                        let values = ["NotesSubject": newNotes.notesSubject, "NotesDescription": newNotes.notesDescription, "NotesImageURL": newNotes.notesImageURL, "Username": newNotes.username, "NotesID": newNotes.notesID]
                        notesRef.setValue(values, withCompletionBlock: {(error, ref) in
                            if(error == nil)
                            {
                                self.displayMyAlertMessage(userMessage: "Notes have been posted!", correct: true)
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.view.alpha = 1.0
                                UIApplication.shared.endIgnoringInteractionEvents()
                                //self.navigationController?.popToRootViewController(animated: true)
                            }
                            else
                            {
                                self.displayMyAlertMessage(userMessage: "Error: Notes were not posted.", correct: false)
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.view.alpha = 1.0
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                            }
                        });
                    
                });
            
            }
            else
            {
                print("An error occured while retrieving")
                print(error!.localizedDescription)
            }
        });
        }
    }
    
    func displayMyAlertMessage(userMessage: String, correct: Bool)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        if(correct){
            let okAction = UIAlertAction(title:"OK", style: .default, handler:  { action in self.navigationController?.popViewController(animated: true)})
            myAlert.addAction(okAction)
            
        }
        else{
            let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)});
            myAlert.addAction(okAction)
            
        }
        
        
        
        self.present(myAlert, animated: true, completion: nil);
    }
}


