//
//  OneCategoryViewController.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit
import RealmSwift

class OneCategoryViewController: UITableViewController {
    
    @IBOutlet weak var navBarLabel: UINavigationItem!
    
    var currentTasksList: CategoryModel!
    private var currentTasks: Results<TaskModel>!
    private var completedTasks: Results<TaskModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarLabel.title = currentTasksList.name
        navigationItem.backBarButtonItem?.tintColor = .white
        
        taskFilter()

    }
    
    // MARK: - Table view data source
    
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
        if currentTasksList.tasks.count == 0 {
            return ""
        }
        return section == 0 ? "CURRENT" : "COMPLETED"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task: TaskModel!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
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
    
    // MARK: - UITableView delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var task: TaskModel!
        
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            RealmManager.deleteTask(task)
            self.taskFilter()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.addAndUpdateTaskAlert(task)
            self.taskFilter()
        }
        
        let done = UITableViewRowAction(style: .normal, title: "Done") { _, _ in
            RealmManager.makeTaskDone(task)
            self.taskFilter()
        }
        
        done.backgroundColor = .systemGreen
        
        return [delete, edit, done]
    }
    
    @IBAction func addTaskButtonPushed(_ sender: UIBarButtonItem) {
        addAndUpdateTaskAlert()
    }
    
    
    func taskFilter() {
        currentTasks = currentTasksList.tasks.filter("completion = false")
        completedTasks = currentTasksList.tasks.filter("completion = true")
        
        tableView.reloadData()
    }
    
}

extension OneCategoryViewController {
    
    private func addAndUpdateTaskAlert(_ taskName: TaskModel? = nil) {
        
        var title = "New task"
        var addButton = "Add"
        
        if taskName != nil {
            addButton = "Update"
            title = "Edit task"
        }
        
        let alertController = UIAlertController(title: title, message: "Title", preferredStyle: .alert)
        
        var alertNoteTextField: UITextField!
        
        // MARK: - Alert buttons setup
        
        let addAction = UIAlertAction(title: addButton, style: .default) { (alert) in
            guard
                let textField = alertController.textFields?[0].text, !textField.isEmpty else {
                    return
                }
            if let taskName = taskName {
                if let newNote = alertNoteTextField.text, !newNote.isEmpty {
                    RealmManager.editTaskData(taskName, newName: textField, newNote: newNote)
                } else {
                    RealmManager.editTaskData(taskName, newName: textField, newNote: "")
                }
                self.taskFilter()
            } else {
                let newTask = TaskModel()
                newTask.name = textField
                
                if let noteTextField = alertNoteTextField.text , !noteTextField.isEmpty {
                    newTask.note = noteTextField
                }
                
                RealmManager.saveTasksData(self.currentTasksList, task: newTask)
                self.taskFilter()
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // MARK: - Alert textFields setup
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Input task name here..."
            if let taskName = taskName {
                textField.text = taskName.name
            }
        }
        
        alertController.addTextField { (noteTextField) in
            alertNoteTextField = noteTextField
            noteTextField.placeholder = "Additional info here"
            if let taskName = taskName {
                noteTextField.text = taskName.note
            }
        }
        present(alertController, animated: true, completion: nil)
    }
    
}
