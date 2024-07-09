//
//  TaskModel.swift
//  Midterm
//
//  Created by Admin on 2024-06-28.
//

import Foundation
// Enumeration to define the possible statuses of a task
enum TaskStatus:String, Codable {
    case pending = "Pending"
    case completed = "Completed"
    case ongoing = "Ongoing"
}

// Class to represent a task color with a selection status
class TaskColor:Codable {
    var color: String?
    var isSeleted: Bool? = false
    // Initializer for TaskColor
    init(color: String? = nil, isSeleted: Bool? = nil) {
        self.color = color
        self.isSeleted = isSeleted
    }
}

// Struct to represent a task with various attributes
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

// Class responsible for generating unique IDs
class IDGenerator {
    private static var currentID: Int = 0
    
    /**
        Generates a unique ID for tasks.
        
        - Returns: A unique integer ID.
        */
    static func generateID() -> Int {
        self.currentID += 1
        return currentID
    }
    /**
        Generates a UUID string.
        
        - Returns: A unique UUID string.
        */
    
    func generateUUID() -> String {
        return UUID().uuidString
    }
}
