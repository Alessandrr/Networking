//
//  CourseCell.swift
//  Networking
//
//  Created by Aleksandr Mamlygo on 19.06.23.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet var courseImage: UIImageView!
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var numberOfLessons: UILabel!
    @IBOutlet var numberOfTests: UILabel!
    
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        numberOfLessons.text = "Number of lessons: \(course.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of tests: \(course.numberOfTests ?? 0)"
        
        NetworkManager.shared.fetchImage(from: course.imageUrl) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.courseImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
