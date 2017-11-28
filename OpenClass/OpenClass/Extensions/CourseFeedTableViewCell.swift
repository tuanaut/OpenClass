//
//  CourseFeedCellTableViewCell.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/10/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

class CourseFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var CourseNumberLabel: UILabel!
    @IBOutlet weak var CourseNameLabel: UILabel!
    var CourseKey: String!
    
    func setCourse(course: Course) {
        
        CourseNumberLabel.text = course.CourseName
        CourseNameLabel.text = course.CourseDescription
        CourseKey = course.CourseKey
        
        CourseNumberLabel.textAlignment = .center
        CourseNameLabel.textAlignment = .center
        
        CourseNumberLabel.numberOfLines = 0
        CourseNameLabel.numberOfLines = 0
    }
}
