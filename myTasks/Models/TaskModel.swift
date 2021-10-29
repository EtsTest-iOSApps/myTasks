//
//  TaskTitle.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import RealmSwift
import Foundation

class TaskModel: Object {
    
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var completion = false

}
