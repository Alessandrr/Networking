//
//  NewCourseViewController.swift
//  Networking
//
//  Created by Aleksandr Mamlygo on 28.06.23.
//

import UIKit

class NewCourseViewController: UIViewController {

    @IBOutlet var courseTitleTF: UITextField!
    @IBOutlet var numberOfLessonsTF: UITextField!
    @IBOutlet var numberOfTestsTF: UITextField!
    
    var delegate: NewCourseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let course = Course(
            name: courseTitleTF.text ?? "",
            imageUrl: Link.courseImageURL.rawValue,
            numberOfLessons: Int(numberOfLessonsTF.text ?? "") ?? 0,
            numberOfTests: Int(numberOfTestsTF.text ?? "") ?? 0
        )
        
        delegate?.sendPostRequest(with: course)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
