//
//  MainTableViewController.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

protocol CategoryDelegate {
    func transferData(model: CategoryModel)
}

class MainTableViewController: UITableViewController {
    
    var categoryObject = CategoryModel(title: "")
    var temporaryArray: [CategoryModel] = [CategoryModel(title: "Home"), CategoryModel(title: "Work"), CategoryModel(title: "Fun")]
    
    var delegate: CategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return temporaryArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
        cell.configureCell(model: temporaryArray[indexPath.section])
        self.delegate?.transferData(model: temporaryArray[indexPath.item])
        return cell
    }
    
    @IBAction func addCategoryButtonPushed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Title", message: "Title", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Input category name here..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (alert) in
            if let textField = alertController.textFields?[0].text {
                self.categoryObject.title = textField
                self.temporaryArray.append(self.categoryObject)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
