//
//  Task.swift
//  ABCDo
//
//  Created by 吕庭锐 on 2024/8/28.
//

import Foundation

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var description: String?
    var startDate: Date
    var endDate: Date
    var priority: Int
    var reminders: [Date] = []// 新增属性
}
