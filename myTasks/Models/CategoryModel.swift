//
//  CategoryModel.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import RealmSwift
import Foundation

class CategoryModel: Object {
    
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks: List<TaskModel>

}
