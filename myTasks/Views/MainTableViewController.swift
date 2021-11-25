//
//  MainTableViewController.swift
//  myTasks
//
//  Created by Максим Хлесткин on 26.10.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    @IBOutlet private weak var segmentedController: UISegmentedControl?
    @IBOutlet private var table: UITableView?
    
    private var categories: Results<CategoryModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupSegmentedController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        filter(with: sender)
    }
    
    @IBAction func addCategoryButtonPushed(_ sender: UIBarButtonItem) {
        addAndUpdateAlert()
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CategoriesTableViewConstants.numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureCells(for: indexPath, tableView)
    }
    
    // MARK: - UITableViewDelegates
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CategoriesTableViewConstants.heighForHeaderAndFooter
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CategoriesTableViewConstants.heighForRow
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CategoriesTableViewConstants.heighForHeaderAndFooter
    }
    
    // MARK: - UISwipeActionsConfiguration
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = categories[indexPath.section]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            self.acceptDeletion(currentList, indexPath: indexPath)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _,_,_ in
            self.addAndUpdateAlert(currentList, completion: {
                tableView.reloadRows(at: [indexPath], with: .none)
                self.segmentedControlPressed(self.segmentedController!)
            })
        }
        
        let done = UIContextualAction(style: .normal, title: "Done") {_,_,_ in
            RealmManager.makeAllTasksDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        done.backgroundColor = .systemGreen
        delete.backgroundColor = .systemRed
        
        var actions = [delete, edit, done]
        
        if currentList.tasks.isEmpty {
            actions.removeLast()
        } else if currentList.tasks.filter("completion = false").count == 0 {
            actions.removeLast()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: actions)
        return swipeActions
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigation(for: segue)
    }
    
    // MARK: - Private: Fetch Data
    
    private func fetchData() {
        categories = RealmManager.realm.objects(CategoryModel.self)
        categories = categories.sorted(byKeyPath: "name")
    }
    
    // MARK: - Private: SegmentedController
    
    private func setupSegmentedController() {
        segmentedController?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    // MARK: - Private: Filter
    
    private func filter(with sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            categories = categories.sorted(byKeyPath: "date")
        } else {
            categories = categories.sorted(byKeyPath: "name")
        }
        tableView.reloadData()
    }
    
    // MARK: - Private: UITableView
    
    private func configureCells(for indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
        let tasksList = categories[indexPath.section]
        cell.configureCell(tasksList)
        return cell
    }
    
    // MARK: - Private: Navigation
    
    private func navigation(for segue: UIStoryboardSegue) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let taskList = categories[indexPath.section]
            guard let tasksVC = segue.destination as? OneCategoryViewController else { return }
            tasksVC.currentTasksList = taskList
        }
    }
    
}

// MARK: - Extensions

extension MainTableViewController: UITextFieldDelegate {
    private func addAndUpdateAlert(_ category: CategoryModel? = nil, completion: (() -> Void)? = nil) {
        var title = "New list"
        var addButton = "Add"
        
        if category != nil {
            title = "Edit category"
            addButton = "Update"
        }
        
        let alertController = UIAlertController(title: title,
                                                message: "Please add new category",
                                                preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Input category name here..."
        }
        
        let addAction = UIAlertAction(title: addButton, style: .default) { _ in
            guard let textField = alertController.textFields?[0].text, !textField.isEmpty else { return }
            if let categoryName = category {
                RealmManager.editCategoryData(categoryName, newName: textField)
                if completion != nil { completion!() }
            } else {
                let newCategory = CategoryModel(value: ["name" : textField])
                RealmManager.saveCategoriesData([newCategory])
                self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .automatic)
                self.segmentedControlPressed(self.segmentedController!)
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
    
    private func acceptDeletion(_ category: CategoryModel, indexPath: IndexPath) {
        let deleteAlert = UIAlertController(title: "Delete List",
                                            message: "Do you really want to delete this list?",
                                            preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            RealmManager.deleteCategory(category)
            self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancelButton)
        present(deleteAlert, animated: true, completion: nil)
    }
    
}

