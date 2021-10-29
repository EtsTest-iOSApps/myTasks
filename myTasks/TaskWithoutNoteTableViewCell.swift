//
//  TaskWithoutNoteTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 28.10.2021.
//

import UIKit

class TaskWithoutNoteTableViewCell: UITableViewCell {
    
 
    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var taskCheckmark: UIImageView!
    
    static let identifier = "TaskCellWithoutNote"
    
    func configureCell(model: TaskModel) {
        taskTitle.text = model.name
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
