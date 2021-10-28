//
//  Realm Manager.swift
//  myTasks
//
//  Created by Максим Хлесткин on 27.10.2021.
//

import RealmSwift

let realm = try! Realm()

class RealmManager {
    
    // MARK: - Save data methods
    
    static func saveCategoriesData(tasksList: [CategoryModel]) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func saveTasksData(tasksList: CategoryModel, task: TaskModel) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
    // MARK: - Delete data methods
    
    static func deleteCategory(tasksList: CategoryModel) {
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    // MARK: - Edit data methods
    
    static func editFunc(_ tasksList: CategoryModel, newName: String) {
        try! realm.write {
            tasksList.name = newName
        }
    }
}
