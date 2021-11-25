//
//  Realm Manager.swift
//  myTasks
//
//  Created by Максим Хлесткин on 27.10.2021.
//

import RealmSwift

class RealmManager {
    
    // MARK: - Save data methods
    
    static let realm = try! Realm()
        
    static func saveCategoriesData(_ tasksList: [CategoryModel]) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func saveTasksData(_ tasksList: CategoryModel, task: TaskModel) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
    // MARK: - Delete data methods
    
    static func deleteCategory(_ tasksList: CategoryModel) {
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    static func deleteTask (_ task: TaskModel) {
        try! realm.write() {
            realm.delete(task)
        }
    }
    
    // MARK: - Edit data methods
    
    static func editCategoryData(_ tasksList: CategoryModel, newName: String) {
        try! realm.write {
            tasksList.name = newName
        }
    }
    
    static func editTaskData(_ task: TaskModel, newName: String, newNote: String) {
        try! realm.write {
            task.name = newName
            task.note = newNote
        }
    }
    
    // MARK: - Update data methods
    
    static func makeAllTasksDone(_ tasksList: CategoryModel) {
        try! realm.write {
            tasksList.tasks.setValue(true, forKey: "completion")
        }
    }
    
    static func makeTaskDone(_ task: TaskModel) {
        try! realm.write() {
            task.completion.toggle()
        }
    }
     
}
