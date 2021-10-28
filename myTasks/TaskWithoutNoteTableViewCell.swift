//
//  TaskWithoutNoteTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 28.10.2021.
//

import UIKit

class TaskWithoutNoteTableViewCell: UITableViewCell {
    
 
    @IBOutlet weak var taskTitle: UILabel!
    
    static let identifier = "TaskCellWithoutNote"
    
    func configureCell(model: TaskModel) {
        taskTitle.text = model.name
    }

}
