//
//  AnswersViewControllerTableViewCell.swift
//  OpenClass
//
//  Created by oscar on 11/14/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class AnswersViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var commentCellView: UIView!
    @IBOutlet weak var commentUserName: UILabel!
    @IBOutlet weak var commentResponse: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
