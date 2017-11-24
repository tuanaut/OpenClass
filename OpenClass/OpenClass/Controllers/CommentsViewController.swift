//
//  CommentsViewController.swift
//  OpenClass
//
//  Created by Vivian Chau on 11/22/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var commentsArray = [Comment]()
    var passedUsername: String!
    var passedNotesID: String!
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage!{
        return Storage.storage()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var comment: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
   
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = 124
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reset course array to empty every you go back to this view controller and reload table view
        commentsArray.removeAll()
        tableView.reloadData()
        fetchComments()
        tableView.reloadData()
        
        navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.commentLabel.text = commentsArray[indexPath.row].commentPosted
        cell.usernameLabel.text = passedUsername
      
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func commentButton(_ sender: Any) {
        
        if(comment.text?.isEmpty)!{
            displayMyAlertMessage(userMessage: "Please enter a comment")
        }
        else{
            let values = ["Commenter": passedUsername, "Comment": comment.text, "id": passedNotesID ]
            databaseRef.child("comments").childByAutoId().setValue(values)
        }
    }
    
    private func fetchComments(){
        print("notes id here")
        print(passedNotesID)
        let ref = databaseRef.child("comments").queryOrdered(byChild: "id").queryEqual(toValue: passedNotesID)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot)
            in
            print("parent")
            print(snapshot)
            for childSnapshot in snapshot.children {
                print(childSnapshot)
                print("This is child snapshot")
                let newComment = Comment(snapshot: childSnapshot as! DataSnapshot)
                self.commentsArray.append(newComment)
                
            }
            self.tableView.reloadData()
            
        })
        
    }

    
    func displayMyAlertMessage(userMessage: String)
    {
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
