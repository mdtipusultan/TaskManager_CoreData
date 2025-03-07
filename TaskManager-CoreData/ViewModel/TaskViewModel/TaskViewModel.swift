//
//  TaskViewModel.swift
//  TaskManager-CoreData
//
//  Created by MacBook Pro M1 Pro on 3/7/25.
//

import UIKit
import CoreData

class TaskViewModel {
    var tasks: [Task] = []
    var onTasksUpdated: (() -> Void)?
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
    func fetchTasks() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(fetchRequest)
            onTasksUpdated?()
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    func addTask(title: String) {
        let newTask = Task(context: context)
        newTask.title = title
        saveContext()
    }
    
    func deleteTask(at index: Int) {
        context.delete(tasks[index])
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
            fetchTasks()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}
