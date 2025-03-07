//
//  ViewController.swift
//  TaskManager-CoreData
//
//  Created by Tipu Sultan on 3/6/25.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    private var viewModel = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
              viewModel.fetchTasks()
              viewModel.onTasksUpdated = { [weak self] in
                  self?.tableView.reloadData()
              }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //nav button
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "New Task", message: "Enter task name", preferredStyle: .alert)
            alert.addTextField()
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
                self.viewModel.addTask(title: taskName)
            }
            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
    }

    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.tasks[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath.row)
        }
    }

}
