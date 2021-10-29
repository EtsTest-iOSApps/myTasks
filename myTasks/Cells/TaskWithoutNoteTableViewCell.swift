//
//  TaskWithoutNoteTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 28.10.2021.
//

import UIKit

class TaskWithoutNoteTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var taskTitle: UILabel?
    @IBOutlet private weak var taskCheckmark: UIImageView?
    
    static let identifier = "TaskCellWithoutNote"
    
    func configureCell(model: TaskModel) {
        taskTitle?.text = model.name
        Colors.installCheckmarks(model, image: taskCheckmark ?? UIImageView())
    }

}
