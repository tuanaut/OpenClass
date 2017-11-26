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
    
    func setCourse(course: Courses) {
        
        CourseNumberLabel.text = course.courseNumber
        CourseNameLabel.text = course.courseName
        
        CourseNumberLabel.textAlignment = .center
        CourseNameLabel.textAlignment = .center
        
        CourseNumberLabel.numberOfLines = 0
        CourseNameLabel.numberOfLines = 0
    }
}
