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
        setupNavigationBar()
        taskFilter()
    }
    
    @IBAction func addTaskButtonPushed(_ sender: UIBarButtonItem) {
        addAndUpdateTaskAlert()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        CategoryTableViewConstants.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureCells(for: indexPath, tableView)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titleForHeader(in: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CategoryTableViewConstants.heighForHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CategoryTableViewConstants.heighForRow
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    // MARK: - UISwipeActionsConfiguration
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var task: TaskModel!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            self.acceptDeletion(task)
        }
        
        let done = UIContextualAction(style: .normal, title: "Done") { _, _, _ in
            RealmManager.makeTaskDone(task)
            self.taskFilter()
        }
        done.backgroundColor = .systemGreen
        
        let undone = UIContextualAction(style: .normal, title: "Undone") { _, _, _ in
            RealmManager.makeTaskDone(task)
            self.taskFilter()
        }
        undone.backgroundColor = .systemMint
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _,_,_ in
            self.addAndUpdateTaskAlert(task)
        }
        
        var actions = [delete,edit,done]
        
        if task.completion == true {
            actions.removeLast()
            actions.append(undone)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: actions)
        self.taskFilter()
        return swipeActions
    }
    
    // MARK: - Private: Navigation
    
    private func setupNavigationBar() {
        navBarLabel.title = currentTasksList.name
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    // MARK: - Private: Filter
    
    private func taskFilter() {
        currentTasks = currentTasksList.tasks.filter("completion = false")
        completedTasks = currentTasksList.tasks.filter("completion = true")
        tableView.reloadData()
    }
    
    // MARK: - Private: UITableView
    
    private func numberOfRows(in section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    private func titleForHeader(in section: Int) -> String? {
        if currentTasksList.tasks.count == 0 {
            return ""
        }
        return section == 0 ? "CURRENT" : "COMPLETED"
    }
    
    private func configureCells(for indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let task: TaskModel?
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        if task?.note == "" {
            guard
                let cellWithoutNote = tableView.dequeueReusableCell(withIdentifier: TaskWithoutNoteTableViewCell.identifier, for: indexPath) as? TaskWithoutNoteTableViewCell else {
                    return UITableViewCell()
                }
            cellWithoutNote.configureCell(model: task ?? TaskModel())
            return cellWithoutNote
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
                    return UITableViewCell()
                }
            cell.configureCell(model: task ?? TaskModel())
            return cell
        }
    }
    
}

// MARK: - Extensions

extension OneCategoryViewController {
    private func addAndUpdateTaskAlert(_ taskName: TaskModel? = nil) {
        var title = "New task"
        var addButton = "Add"
        
        if taskName != nil {
            addButton = "Update"
            title = "Edit task"
        }
        let alertController = UIAlertController(title: title,
                                                message: "Title",
                                                preferredStyle: .alert)
        var alertNoteTextField: UITextField!
        
        // MARK: - Alert buttons setup
        
        let addAction = UIAlertAction(title: addButton, style: .default) { alert in
            guard let textField = alertController.textFields?[0].text, !textField.isEmpty else { return }
            if let taskName = taskName {
                if let newNote = alertNoteTextField.text, !newNote.isEmpty {
                    RealmManager.editTaskData(taskName,
                                              newName: textField,
                                              newNote: newNote)
                } else {
                    RealmManager.editTaskData(taskName,
                                              newName: textField,
                                              newNote: "")
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
    
    private func acceptDeletion(_ task: TaskModel) {
        let deleteAlert = UIAlertController(title: "Delete Task",
                                            message: "Do you really want to delete this task?",
                                            preferredStyle: .actionSheet)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            RealmManager.deleteTask(task)
            self.taskFilter()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancelButton)
        present(deleteAlert, animated: true, completion: nil)
    }
    
}
