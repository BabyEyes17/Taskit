// Authored by Jayden Lewis on 08/02/2026

import SwiftUI
import UserNotifications

@main
struct TaskitApp: App {
    
    let persistence = PersistenceController.shared

    var body: some Scene {

        WindowGroup {
            
            TasksView()
                
                .environment(\.managedObjectContext, persistence.container.viewContext)
            
                .onAppear { UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }}
        }
    }
}
