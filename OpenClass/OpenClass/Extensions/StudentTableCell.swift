//
//  StudentTableCell.swift
//  OpenClass
//
//  Created by Jacob Mann on 12/2/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class StudentTableCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!;
    @IBOutlet weak var enrollmentDateLabel: UILabel!;
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

}

