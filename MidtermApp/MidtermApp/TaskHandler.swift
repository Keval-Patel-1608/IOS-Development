//
//  TaskHandler.swift
//  MidtermApp
//
//  Created by Keval on 8/3/24.
//
// This is a Singelton class 
import Foundation

class TaskHandler {
    
    static let shared = TaskHandler()
    
    private var tasks: [TaskModel] = [] {
        didSet {
            saveTasks()
        }
    }
    
    private init() {
        retriveTasks()
    }
    
    func addTask(_ task: TaskModel) {
        tasks.append(task)
    }
    
    func getTasks() -> [TaskModel] {
        return tasks
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
        saveTasks()
    }
    

    func retriveTasks() {
        if let savedTasks = UserDefaults.standard.object(forKey: "Task") as? Data {
            if let decodedTasks = try? JSONDecoder().decode([TaskModel].self, from: savedTasks) {
                tasks = decodedTasks
            }
        }
    }
    
    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "Task")
        }
    }
}

