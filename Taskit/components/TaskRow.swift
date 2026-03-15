// Authored by Jayden Lewis on 07/02/2026
// This component is called for displaying a task formatted for a VStack with minimal information.
// Supports navigation to the respective task's detailed view via NavigationLink.

import SwiftUI
import CoreData

struct TaskRow: View {
    
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var task: TaskEntity
    
    var body: some View {
        
        NavigationLink(destination: TaskDetailsView(task: task).environment(\.managedObjectContext, context)) {
            
            HStack(spacing: 12) {
                
                // Completion button
                Button { TaskRepository.toggleCompleted(task, context: context) }
                
                label: {
                    
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundStyle(task.isCompleted ? .green : .secondary)
                }
                
                .buttonStyle(.plain)
                
                
                
                // Title and due date display
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(task.title ?? "")
                        .font(.system(size: 17, weight: .semibold))
                        .strikethrough(task.isCompleted, color: .secondary)
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                    
                    Text(task.dueDate?.formatted(using: .weekdayAbbrevMonthDay) ?? "")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                
                
                // Favourite button
                Button { TaskRepository.toggleFavourite(task, context: context) }
                
                label: {
                    
                    Image(systemName: task.isFavourite ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.blue)
                }
                
                .buttonStyle(.plain)
            }
            .buttonStyle(.plain)
        }
    }
}
