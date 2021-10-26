//
//  TaskTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    
    static let identifier = "TaskCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TaskCell", bundle: nil)
    }
    
    func configureCell(model: TaskModel) {
        taskTitle.text = model.title
    }

}
