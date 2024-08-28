//
//  TaskManager.swift
//  ABCDo
//
//  Created by 吕庭锐 on 2024/8/28.
//

import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []

    func addTask(_ task: Task) {
        tasks.append(task)
    }

    func deleteTask(at index: Int) {
        tasks.remove(at: index)
    }
}
