//
//  Course.swift
//  Networking
//
//  Created by Aleksandr Mamlygo on 19.06.23.
//

struct Course: Codable {
    let name: String
    let imageUrl: String
    let numberOfLessons: Int
    let numberOfTests: Int
    
    init(name: String, imageUrl: String, numberOfLessons: Int, numberOfTests: Int) {
        self.name = name
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
    }
    
    init(courseData: [String: Any]) {
        name = courseData["name"] as? String ?? ""
        imageUrl = courseData["imageUrl"] as? String ?? ""
        numberOfLessons = courseData["number_of_lessons"] as? Int ?? 0
        numberOfTests = courseData["number_of_tests"] as? Int ?? 0
    }
    
    static func getCourses(from value: Any) -> [Course] {
        guard let coursesData = value as? [[String: Any]] else { return [] }
        return coursesData.map { Course(courseData: $0) }
    }
    
    init(courseJp: CourseJP) {
        name = courseJp.name
        imageUrl = courseJp.imageUrl
        numberOfLessons = Int(courseJp.numberOfLessons) ?? 0
        numberOfTests = Int(courseJp.numberOfTests) ?? 0
    }
}

struct CourseJP: Codable {
    let name: String
    let imageUrl: String
    let numberOfLessons: String
    let numberOfTests: String
}


struct SwiftbookInfo: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
