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
}

enum Link: String {
    case imageURL = "https://www.warhammer-community.com/wp-content/uploads/2020/11/LngwA6oHyz5obPnL.jpg"
    case courseURL = "https://swiftbook.ru/wp-content/uploads/api/api_course"
    case coursesURL = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    case websiteDescription = "https://swiftbook.ru/wp-content/uploads/api/api_website_description"
    case websiteMissingInfo = "https://swiftbook.ru/wp-content/uploads/api/api_missing_or_wrong_fields"
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
        case .fetchCourses: fetchCourses()
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutUsWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        guard let url = URL(string: Link.courseURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let course = try decoder.decode(Course.self, from: data)
                print(course)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            }
            
        }.resume()
    }
    
    func fetchCourses() {
        guard let url = URL(string: Link.coursesURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let courses = try decoder.decode([Course].self, from: data)
                print(courses)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            }
            
        }.resume()
    }
    
    func fetchInfoAboutUs() {
        guard let url = URL(string: Link.websiteDescription.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let info = try decoder.decode(SwiftbookInfo.self, from: data)
                print(info)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(.failed)
                }
            }
            
        }.resume()
    }
    
    func fetchInfoAboutUsWithEmptyFields() {
        guard let url = URL(string: Link.websiteMissingInfo.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let info = try decoder.decode(SwiftbookInfo.self, from: data)
                print(info)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(.success)
                }
            }
            
        }.resume()
    }
}