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
    }
}

