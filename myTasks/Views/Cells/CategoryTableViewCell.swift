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
        categoryTitle?.text = model.name
        Checkmarks.configure(for: categoryDetail, from: model)
    }
    
}
