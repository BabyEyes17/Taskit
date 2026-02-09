// Authored by Jayden Lewis on 07/02/2026
// TaskDetailsView.swift

import SwiftUI

struct TaskDetailsView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var task: Task

    var body: some View {

        ZStack {
            
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {

                // Back button
                HStack {
                    
                    Button { dismiss() } label: {
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemBackground).opacity(0.85))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }

                // Title
                Text(task.title)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 4)

                // Card
                TaskDetailCard(
                    category: task.category,
                    description: task.description,
                    dueDateText: task.dueDate.formattedDueDate(),
                    notificationText: notificationText,
                    repeatText: repeatText,
                    tags: task.tags
                )

                // Actions
                TaskDetailActions(
                    
                    isCompleted: $task.isCompleted,
                    
                    onEdit: {
                        print("Edit tapped")
                    },
                    
                    onDelete: {
                        print("Delete tapped")
                    }
                )

                Spacer()
            }
            
            .padding(.horizontal, 20)
            .padding(.top, 14)
        }
        
        .navigationBarBackButtonHidden(true)
    }
    
    private var notificationText: String {
        
        guard task.notificationsEnabled else { return "Notifications off" }

        if let minutes = task.notifyBeforeMinutes {
            return "Notify me \(minutes.minutesToFriendlyString()) before"
        }

        return "Notifications on"
    }

    private var repeatText: String {
        
        if task.repeatRule == .none {
            return "Repeat: Never"
        }
        
        return "Repeat: \(task.repeatRule.rawValue)"
    }
}

#Preview {
    
    let store = TaskStore.preview

    NavigationStack {
        TaskDetailsView(task: .constant(store.tasks[0]))
    }
}

