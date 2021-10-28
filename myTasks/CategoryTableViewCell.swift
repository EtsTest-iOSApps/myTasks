//
//  CategoryTableViewCell.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var categoryDetail: UILabel!
    
    static let identifier = "CategoryCell"
    
    func configureCell(model: CategoryModel) {
        categoryTitle.text = model.name
        categoryDetail.text = "\(model.tasks.count)"
    }
}
