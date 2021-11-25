//
//  Worker.swift
//  myTasks
//
//  Created by Максим Хлесткин on 05.11.2021.
//

import Foundation
import UIKit

class Checkmarks {
    
    static func configure(for image: UIImageView?, from task: TaskModel) {
        let inProgressConfig = UIImage.SymbolConfiguration(pointSize: 10,
                                                       weight: .bold,
                                                       scale: .small)
        if task.completion == true {
            image?.image = UIImage(systemName: "checkmark.circle")
        } else {
            image?.image = UIImage(systemName: "circle.fill", withConfiguration: inProgressConfig)
        }
    }
    
    static func configure(for label: UILabel?, from category: CategoryModel) {
        let currentTasks = category.tasks.filter("completion = false")
        let completedTasks = category.tasks.filter("completion = true")
        
        if currentTasks.count != 0 {
            label?.text = "In progress: \(currentTasks.count)"
            label?.textColor = UIColor.systemGray
            label?.font = UIFont.systemFont(ofSize: 17)
        } else if completedTasks.count != 0 {
            label?.text = "✓"
            label?.textColor = UIColor.systemBlue
            label?.font = .boldSystemFont(ofSize: 20)
        } else {
            label?.text = "Empty"
            label?.textColor = UIColor.systemGray
            label?.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
}
