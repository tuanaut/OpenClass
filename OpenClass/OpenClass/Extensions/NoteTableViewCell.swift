//
//  QuestionTableViewCell.swift
//  OpenClass
//
//  Created by Tuan Chau on 11/20/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

   
    // @IBOutlet weak var subjectTextField: UITextField!
    //@IBOutlet weak var descripitonTextField: UITextField!
    //@IBOutlet weak var postedbyTextField: UITextField!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
