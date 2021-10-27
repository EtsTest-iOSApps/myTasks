//
//  OneCategoryViewController.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit

class OneCategoryViewController: UITableViewController, CategoryDelegate {
    
    @IBOutlet weak var navBarLabel: UINavigationItem!
    
    var test1 = "Tasks"
    
    var temporaryTask: [TaskModel] = [TaskModel(title: "Hi")]
    var manager = MainTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self

    }
    
    // MARK: - Table view data source
    
    func transferData(model: CategoryModel) {
        test1 = model.title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temporaryTask.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
                return UITableViewCell()
            }
        cell.configureCell(model: temporaryTask[indexPath.row])
        navBarLabel.title = test1
        return cell
    }
    
    @IBAction func addTaskButtonPushed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Title", message: "Title", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Input task name here..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (alert) in
            if let textField = alertController.textFields?[0].text {
                var taskObject = TaskModel(title: "")
                taskObject.title = textField
                self.temporaryTask.append(taskObject)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
