//
//  NotesFeedViewController.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/20/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class NotesFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var passedCourseKey: String!
    var NotesArray = [Notes]()
    var valueToPass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Notes", style: .plain, target: self, action: #selector(AddNotes))
        
       tableView.delegate = self 
        tableView.dataSource = self
        navigationController?.isNavigationBarHidden = false
        tableView.estimatedRowHeight = 117
        tableView.rowHeight = 117
        
        // Expand row height based on amount of text
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide excess cells in table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //automaticallyAdjustsScrollViewInsets = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reset course array to empty every you go back to this view controller and reload table view
       NotesArray.removeAll()
        tableView.reloadData()
        
        navigationController?.isNavigationBarHidden = false
        print("Before")
        print(NotesArray.count)
        fetchNotesForCourse()
        tableView.reloadData()
        print("After")
        print(NotesArray.count)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func AddNotes() {
        
        self.performSegue(withIdentifier: "GoToAddNewNotes", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesArray.count
    }
    
   /* func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "GoToAddNewNotes"){
            let viewController = segue.destination as! NewClassNotesViewController
            viewController.passedkey = passedCourseKey
            
        }
        else if(segue.identifier == "GoToSelectedNotes"){
            let viewController = segue.destination as! SelectedNotesViewController
            viewController.passedNotesID = valueToPass
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NoteTableViewCell
        cell.subjectLabel.text = NotesArray[indexPath.row].notesSubject
        cell.usernameLabel.text = NotesArray[indexPath.row].username
       
        return cell
    }
    
    
    private func fetchNotesForCourse(){
        
        let ref = Database.database().reference()
        
        
        let query = ref.child("notes").queryOrdered(byChild: "CourseKey").queryEqual(toValue: passedCourseKey)
        print("The current key is")
        print(passedCourseKey)
        
        query.observeSingleEvent(of: .value, with: {(notes)
                    in
            
                    print("All notes")
                    print(notes)
                    for note in notes.children {
                        let newNote = Notes(snapshot: note as! DataSnapshot)
                        self.NotesArray.append(newNote)
                        
                        print("Temp Array Count:")
                        print(self.NotesArray.count)
                    }
            
                self.tableView.reloadData()
            
                print("Real Array Count:")
                print(self.NotesArray.count)
                })
        print("Outside closure")
        print(NotesArray.count)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            NotesArray.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let row:Notes = NotesArray[indexPath.row]
        
        valueToPass = row.notesID
        
        performSegue(withIdentifier: "GoToSelectedNotes", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
