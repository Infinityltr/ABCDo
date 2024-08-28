//
//  NotificationManager.swift
//  ABCDo
//
//  Created by 吕庭锐 on 2024/8/28.
//

import Foundation
import UserNotifications

class NotificationManager {
    func scheduleNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = "Your task is about to start!"
        content.sound = UNNotificationSound.default

        let timeInterval = task.startDate.timeIntervalSinceNow
        
        // 即使时间间隔小于等于0，也允许任务保存，只是不设置通知
        if timeInterval > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            print("Task \(task.title) is in the past. No notification will be scheduled.")
        }
    }

    func cancelNotification(for task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
}
