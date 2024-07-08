//
//  TaskModel.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
//

import Foundation

enum TaskStatus:String, Codable {
    case pending = "Pending"
    case completed = "Completed"
    case ongoing = "Ongoing"
}

class TaskColor:Codable {
    var color: String?
    var isSeleted: Bool? = false
    
    init(color: String? = nil, isSeleted: Bool? = nil) {
        self.color = color
        self.isSeleted = isSeleted
    }
}

struct Task: Codable {
    var taskId: Int? = IDGenerator.generateID()
    var title: String?
    var taskDescription: String?
    var strDate: String?
    var dateValue: Date?
    var color: TaskColor?
    var image: String?
    var status: TaskStatus? = .pending
}

class IDGenerator {
    private static var currentID: Int = 0
    
    static func generateID() -> Int {
        self.currentID += 1
        return currentID
    }
    
    func generateUUID() -> String {
        return UUID().uuidString
    }
}
