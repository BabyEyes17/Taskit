// Authored by Jayden Lewis on 04/02/2026

import CoreData
import SwiftUI
import UserNotifications

struct TaskRepository {
    
    static func addTask(
        
        title: String,
        taskDescription: String,
        category: String,
        dueDate: Date,
        notificationsEnabled: Bool,
        notifyBeforeMinutes: Int16,
        repeatRule: String,
        tags: [String],
        context: NSManagedObjectContext
    ) -> TaskEntity {
        
        let task = TaskEntity(context: context)
        
        task.id = UUID()
        task.title = title
        task.taskDescription = taskDescription
        task.category = category
        task.dueDate = dueDate
        task.notificationsEnabled = notificationsEnabled
        task.notifyBeforeMinutes = notifyBeforeMinutes
        task.repeatRule = repeatRule
        task.tags = tags as NSArray
        task.isCompleted = false
        task.isFavourite = false
        
        save(context: context)
        return task
    }
    
    static func deleteTask(_ task: TaskEntity, context: NSManagedObjectContext) {
        
        context.delete(task)
        save(context: context)
    }
    
    static func toggleCompleted(_ task: TaskEntity, context: NSManagedObjectContext) {
        
        task.isCompleted.toggle()
        save(context: context)
    }
    
    static func toggleFavourite(_ task: TaskEntity, context: NSManagedObjectContext) {
        
        task.isFavourite.toggle()
        save(context: context)
    }
    
    static func save(context: NSManagedObjectContext) {
        
        guard context.hasChanges else { return }
        try? context.save()
    }
    
    static func scheduleNotification(for task: TaskEntity) {
        
        guard task.notificationsEnabled,
              task.notifyBeforeMinutes > 0,
              let dueDate = task.dueDate,
              let taskId = task.id?.uuidString
                
        else { return }
        
        let triggerDate = dueDate.addingTimeInterval(-Double(task.notifyBeforeMinutes) * 60)
        guard triggerDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Taskit Reminder"
        content.subtitle = task.category ?? ""
        content.body = "Due in \(Int(task.notifyBeforeMinutes).minutesToFriendlyString())"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: taskId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    static func cancelNotification(for task: TaskEntity) {
        
        guard let taskId = task.id?.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
    }
}
