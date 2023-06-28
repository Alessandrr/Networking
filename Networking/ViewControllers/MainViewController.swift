//
//  ViewController.swift
//  Networking
//
//  Created by Aleksandr Mamlygo on 19.06.23.
//

import UIKit

enum UserAction: String, CaseIterable {
    case showImage = "Show Image"
    case fetchCourse = "Fetch Course"
    case fetchCourses = "Fetch Courses"
    case aboutSwiftBook = "About SwiftBook"
    case aboutSwiftBook2 = "About SwiftBook 2"
    case showCourses = "Show Courses"
    case postRequestWithDict = "POST RQST with Dict"
    case postRequestWithModel = "POST RQST with Model"
}

enum Link: String {
    case imageURL = "https://www.warhammer-community.com/wp-content/uploads/2020/11/LngwA6oHyz5obPnL.jpg"
    case courseURL = "https://swiftbook.ru/wp-content/uploads/api/api_course"
    case coursesURL = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    case websiteDescription = "https://swiftbook.ru/wp-content/uploads/api/api_website_description"
    case websiteMissingInfo = "https://swiftbook.ru/wp-content/uploads/api/api_missing_or_wrong_fields"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
    case courseImageURL = "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png"
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see results in the debug area"
        case .failed:
            return "You can see the error in the debug area"
        }
    }
}

class MainViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases

    //MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "userAction",
            for: indexPath
        )
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell()}
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        switch userAction {
        case .showImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchCourse: fetchCourse()
        case .fetchCourses: break
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutUsWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        case .postRequestWithDict: postRequestWithDict()
        case .postRequestWithModel: postRequestWithModel()
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourses" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.fetchCourses()
        }
    }
    
    // MARK: - Private methods
    private func showAlert(_ alert: Alert) {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.window?.windowScene?.screen.bounds.width ?? 200) - 48, height: 100)
    }
}

// MARK: - Networking

private extension MainViewController {
    func fetchCourse() {
        NetworkManager.shared.fetch(Course.self, from: Link.courseURL.rawValue) { [weak self] result in
            switch result {
            case .success(let course):
                print(course)
                self?.showAlert(.success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(.failed)
            }
        }
    }
    
    func fetchCourses() {
        NetworkManager.shared.fetch([Course].self, from: Link.coursesURL.rawValue) { [weak self] result in
            switch result {
            case .success(let info):
                print(info)
                self?.showAlert(.success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(.failed)
            }
        }
    }
    
    func fetchInfoAboutUs() {
        NetworkManager.shared.fetch(SwiftbookInfo.self, from: Link.websiteDescription.rawValue) { [weak self] result in
            switch result {
            case .success(let info):
                print(info)
                self?.showAlert(.success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(.failed)
            }
        }
    }
    
    func fetchInfoAboutUsWithEmptyFields() {
        NetworkManager.shared.fetch(SwiftbookInfo.self, from: Link.websiteMissingInfo.rawValue) { [weak self] result in
            switch result {
            case .success(let info):
                print(info)
                self?.showAlert(.success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(.failed)
            }
        }
    }
    
    func postRequestWithDict() {
        let course = [
            "name": "Network",
            "imageURL": "imageurl",
            "numberOfLessons": "10",
            "numberOfTests": "80"
        ]
        
        NetworkManager.shared.postRequest(with: course, to: Link.postRequest.rawValue) { [weak self] result in
            switch result {
            case .success(let json):
                print(json)
                self?.showAlert(.success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(.failed)
            }
        }
    }
    
    func postRequestWithModel() {
        let course = Course(
            name: "Networking",
            imageUrl: Link.imageURL.rawValue,
            numberOfLessons: 10,
            numberOfTests: 5
        )
        
        NetworkManager.shared.postRequest(with: course, to: Link.postRequest.rawValue) { [weak self] result in
            switch result {
            case .success(let course):
                print(course)
                self?.showAlert(.success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(.failed)
            }
        }
    }
}
