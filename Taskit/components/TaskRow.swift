// Authored by Jayden Lewis on 07/02/2026
// This component is called for displaying a task formatted for a VStack with minimal information
// For final implementation, this component will support navigation to the respective task's detailed view

import SwiftUI

struct TaskRow: View {
    
    @Binding var task: Task

    var body: some View {
        
        HStack(spacing: 12) {



            // Completion button
            Button { task.isCompleted.toggle() } 
            
            label: {
                
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }
            
            .buttonStyle(.plain)



            // Title and due date display
            VStack(alignment: .leading, spacing: 4) {
                
                Text(task.title)
                    .font(.system(size: 17, weight: .semibold))
                    .strikethrough(task.isCompleted, color: .secondary)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                Text(task.dueDate.formatted(using: .weekdayAbbrevMonthDay))
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()



            // Favourite button
            Button { task.isFavourite.toggle() } 
            
            label: {
                
                Image(systemName: task.isFavourite ? "star.fill" : "star")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            .buttonStyle(.plain)
        }
        
        .opacity(task.isCompleted ? 0.55 : 1.0)
    }
}
