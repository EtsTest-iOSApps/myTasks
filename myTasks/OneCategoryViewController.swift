//
//  OneCategoryViewController.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit
import RealmSwift

class OneCategoryViewController: UITableViewController, CategoryDelegate {
    
    @IBOutlet weak var navBarLabel: UINavigationItem!
    
    
    var currentTasksList: CategoryModel!
    var currentTasks: Results<TaskModel>!
    var completedTasks: Results<TaskModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskFilter()
        
    }
    
    // MARK: - Table view data source
    
    func transferData(model: CategoryModel) {
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task: TaskModel!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        navBarLabel.title = currentTasksList.name
        
        if task.note == "" {
            guard
                let cellWithoutNote = tableView.dequeueReusableCell(withIdentifier: TaskWithoutNoteTableViewCell.identifier, for: indexPath) as? TaskWithoutNoteTableViewCell else {
                    return UITableViewCell()
                }
            cellWithoutNote.configureCell(model: task)
            return cellWithoutNote
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
                    return UITableViewCell()
                }
            cell.configureCell(model: task)
            return cell
        }
    }
    
    @IBAction func addTaskButtonPushed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Title", message: "Title", preferredStyle: .alert)
        
        var alertNoteTextField: UITextField!
        
        // MARK: - Alert buttons setup
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (alert) in
            guard
                let textField = alertController.textFields?[0].text, !textField.isEmpty else { return }
            
            let newTask = TaskModel()
            newTask.name = textField
            
            if let noteTextField = alertNoteTextField.text , !noteTextField.isEmpty {
                newTask.note = noteTextField
            }
            
            RealmManager.saveTasksData(tasksList: self.currentTasksList, task: newTask)
            self.taskFilter()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // MARK: - Alert textFields setup
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Input task name here..."
        }
        
        alertController.addTextField { (noteTextField) in
            alertNoteTextField = noteTextField
            noteTextField.placeholder = "Additional info here"
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func taskFilter() {
        currentTasks = currentTasksList.tasks.filter("completion = false")
        completedTasks = currentTasksList.tasks.filter("completion = true")
        
        tableView.reloadData()
    }
}

