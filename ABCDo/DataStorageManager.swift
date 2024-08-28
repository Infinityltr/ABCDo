//
//  DataStorageManager.swift
//  ABCDo
//
//  Created by 吕庭锐 on 2024/8/28.
//

import Foundation
import CoreData

class DataStorageManager {
    static let shared = DataStorageManager()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ABCDOModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data stores: \(error)")
            }
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    func saveTask(_ task: Task) {
        let context = container.viewContext
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.taskDescription = task.description
        taskEntity.startDate = task.startDate
        taskEntity.endDate = task.endDate
        taskEntity.priority = Int16(task.priority)

        saveContext()
    }

    func loadTasks() -> [Task] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { Task(id: $0.id!, title: $0.title!, description: $0.taskDescription, startDate: $0.startDate!, endDate: $0.endDate!, priority: Int($0.priority)) }
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
}

