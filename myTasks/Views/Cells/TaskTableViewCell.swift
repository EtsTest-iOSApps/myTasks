//
//  TaskTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var taskCheckmark: UIImageView?
    @IBOutlet private weak var taskTitle: UILabel?
    @IBOutlet private weak var noteTitle: UILabel?
    
    static let identifier = "TaskCell"
    
    func configureCell(model: TaskModel) {
        taskTitle?.text = model.name
        noteTitle?.text = model.note
        Checkmarks.configure(for: taskCheckmark, from: model)
    }
    
}

