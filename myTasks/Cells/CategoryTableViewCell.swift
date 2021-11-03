//
//  CategoryTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var categoryTitle: UILabel?
    @IBOutlet private weak var categoryDetail: UILabel?
    
    static let identifier = "CategoryCell"
    
    func configureCell(_ model: CategoryModel) {
        let currentTasks = model.tasks.filter("completion = false")
        let completedTasks = model.tasks.filter("completion = true")
        
        categoryTitle?.text = model.name
        
        if currentTasks.count != 0 {
            categoryDetail?.text = "In progress: \(currentTasks.count)"
            categoryDetail?.textColor = UIColor.systemGray
            categoryDetail?.font = UIFont.systemFont(ofSize: 17)
        } else if completedTasks.count != 0 {
            categoryDetail?.text = "✓"
            categoryDetail?.textColor = UIColor.green
            categoryDetail?.font = .boldSystemFont(ofSize: 20)
        } else {
            categoryDetail?.text = "Empty"
            categoryDetail?.textColor = UIColor.systemGray
            categoryDetail?.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
}
