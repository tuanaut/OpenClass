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

class NewClassNotesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @IBOutlet weak var NotesSubjectText: UITextField!
    
    @IBOutlet weak var NotesDescriptionText: UITextField!
    //let pickerController = UIImagePickerController()
    
    @IBOutlet weak var NotesImage: UIImageView!{
        didSet{
            NotesImage.layer.cornerRadius = 5
        }
    }
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage!{
        return Storage.storage()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(PostNotes))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectImage(_ sender: Any) {
      
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose Photo", message: "From Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion:nil)            }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion:nil)
            }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        NotesImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func PostNotes(){
        
        let imageData = UIImageJPEGRepresentation(NotesImage.image!, 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        //let uid = Auth.auth().currentUser?.uid
        
        let imagePath = "notesImage\(Auth.auth().currentUser!.uid)/notesPic.jpg"
        
        let imageRef = storageRef.reference().child(imagePath)
        imageRef.putData(imageData!, metadata: metaData, completion: {(newMetaData, error) in
            if (error == nil){
                print("OK1")
                let newNotes = Notes(notesSubject: self.NotesSubjectText.text!, notesDescription: self.NotesDescriptionText.text!, notesImageURL: String(describing: newMetaData!.downloadURL()!))
                print("OK3")
                
                let notesRef = Database.database().reference().child("notes").childByAutoId()
                print("OK5")
               let values = ["NotesSubject": newNotes.notesSubject, "NotesDescription": newNotes.notesDescription, "NotesImageURL": newNotes.notesImageURL]
                notesRef.setValue(values, withCompletionBlock: {(error, ref) in
                    if(error == nil) {
                        print("OK2")
                        //self.navigationController?.popToRootViewController(animated: true)
                    }
                
                })
                
            }
            else{
                print("OK4")
                print(error!.localizedDescription)
            }
            
        })
    }
    
}
