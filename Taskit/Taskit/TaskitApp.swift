// Authored by Jayden Lewis on 08/02/2026

import SwiftUI

@main
struct TaskitApp: App {
    
    @StateObject private var taskStore = TaskStore()
    
    var body: some Scene {
        
        WindowGroup {
            
            TasksView().environmentObject(taskStore)
        }
    }
}
