//
//  MainTableViewController.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit
import RealmSwift

protocol CategoryDelegate {
    func transferData(model: CategoryModel)
}

class MainTableViewController: UITableViewController {
        
    @IBOutlet var table: UITableView!
    
    private var categories: Results<CategoryModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = realm.objects(CategoryModel.self)
        
        table.sectionHeaderTopPadding = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return categories.count
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
        let tasksList = categories[indexPath.section]
        cell.configureCell(model: tasksList)
        return cell
    }
    
    @IBAction func addCategoryButtonPushed(_ sender: UIBarButtonItem) {
        addAndUpdateAlert()
    }
    
    // MARK: -  tableView delegate methods
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentList = categories[indexPath.section]
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { _, _ in
            
            RealmManager.deleteCategory(currentList)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.addAndUpdateAlert(currentList, completion: {
                tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        
        let completed = UITableViewRowAction(style: .normal, title: "Done") { _, _ in
            RealmManager.makeAllTasksDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        completed.backgroundColor = .systemGreen
        delete.backgroundColor = .systemRed
        
        return [delete, edit, completed]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let taskList = categories[indexPath.section]
            let tasksVC = segue.destination as! OneCategoryViewController
            tasksVC.currentTasksList = taskList
        }
    }
    
}

extension MainTableViewController: UITextFieldDelegate {
    
    private func addAndUpdateAlert(_ category: CategoryModel? = nil, completion: (() -> Void)? = nil) {
        
        var title = "New list"
        var addButton = "Add"
        
        if category != nil {
            title = "Edit category"
            addButton = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Please insert new category", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Input category name here..."
        }
        
        let addAction = UIAlertAction(title: addButton, style: .default) { (alert) in
            
            guard
                let textField = alertController.textFields?[0].text, !textField.isEmpty else { return }
            
            if let categoryName = category {
                RealmManager.editCategoryData(categoryName, newName: textField)
                if completion != nil { completion!() }
            } else {
                let newCategory = CategoryModel(value: ["name" : textField])
                RealmManager.saveCategoriesData([newCategory])
                
                self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        if category != nil {
            alertController.textFields?[0].text = category?.name
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
