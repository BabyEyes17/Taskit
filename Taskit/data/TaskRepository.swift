// Authored by Jayden Lewis on 04/02/2026

import CoreData
import SwiftUI

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
    ) {
        
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
        try? context.save
    }
}
