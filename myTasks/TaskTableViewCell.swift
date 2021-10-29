//
//  TaskTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskCheckmark: UIImageView!
    
    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var noteTitle: UILabel!
    
    static let identifier = "TaskCell"
    
    func configureCell(model: TaskModel) {
        taskTitle.text = model.name
        noteTitle.text = model.note
        installCheckmarks(model)
    }
    
    private func installCheckmarks(_ task: TaskModel) {
        
        let doneConfig = UIImage.SymbolConfiguration(paletteColors: [.systemGreen, .systemOrange, .systemGreen])
        let undoneConfig = UIImage.SymbolConfiguration(paletteColors: [.systemOrange, .systemOrange, .systemOrange])
        if task.completion == true {
            taskCheckmark.image = UIImage(systemName: "checkmark.circle", withConfiguration: doneConfig)
        } else {
            taskCheckmark.image = UIImage(systemName: "circle", withConfiguration: undoneConfig)
        }
    }
}

