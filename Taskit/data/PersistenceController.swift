// PersistenceController.swift
// Authored by Jayden Lewis on 13/03/2026

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer
        
    init() {
        
        container = NSPersistentContainer(name: "Taskit")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        seedIfNeeded()
    }
    
    private func seedIfNeeded() {
        
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let count = (try? context.count(for: fetchRequest)) ?? 0
        guard count == 0 else { return }
        
        let sampleTasks: [(String, String, String, Int)] = [
            ("Buy groceries", "", "General", 1),
            ("Read a book", "", "School", 1),
            ("Go for a walk", "", "General", 3),
            ("Check work schedule", "", "Work", 4),
            ("Call boss", "Ask for a week off next month.", "Work", 3),
            ("Plan weekend trip", "", "General", 2),
            ("Organize closet", "", "General", 5),
            ("Buy new phone case", "", "General", 6),
            ("Cook dinner for the family", "", "General", 6),
            ("Go to the gym with James", "", "General", 10)
        ]
        
        for (title, taskDescription, category, dayOffset) in sampleTasks {
            
            let task = TaskEntity(context: context)
            
            task.id = UUID()
            task.title = title
            task.taskDescription = taskDescription
            task.category = category
            task.dueDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())
            task.notificationsEnabled = true
            task.notifyBeforeMinutes = 30
            task.repeatRule = "Does Not Repeat"
            task.tags = ["Sample Tag"] as NSArray
            task.isCompleted = false
            task.isFavourite = false
        }
        
        try? context.save()
    }
}

