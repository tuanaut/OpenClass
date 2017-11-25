//
//  CourseFeedCellTableViewCell.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/10/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class CourseFeedTableViewCell: UITableViewCell
{
    @IBOutlet weak var CourseNumberLabel: UILabel!
    @IBOutlet weak var CourseNameLabel: UILabel!
    
    func setCourse(course: Course)
    {
        CourseNumberLabel.text = course.GetKey();
        CourseNameLabel.text = course.GetName();
        
        CourseNumberLabel.textAlignment = .center
        CourseNameLabel.textAlignment = .center
        
        CourseNumberLabel.numberOfLines = 0
        CourseNameLabel.numberOfLines = 0
    }
}
