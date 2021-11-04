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
        Colors.installCheckmarks(model, image: taskCheckmark ?? UIImageView())
        gesture(imageView: taskCheckmark!)
    }
    
    func gesture(imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.imageTapped))
        
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        
    }
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("Tapped")
        }
    }
    
}

