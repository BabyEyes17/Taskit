// Authored by Jayden Lewis on 07/02/2026
// TaskDetailsView.swift

import SwiftUI
import CoreData

struct TaskDetailsView: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var task: TaskEntity

    @State private var showEditSheet    = false
    @State private var showDeleteAlert  = false

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
                Text(task.title ?? "Untitled")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 4)

                // Detail card
                TaskDetailCard(
                    category: task.category ?? "General",
                    description: task.taskDescription ?? "",
                    dueDateText: task.dueDate?.formattedDueDate() ?? "No due date",
                    notificationText: notificationText,
                    repeatText: repeatText,
                    tags: task.tags as? [String] ?? []
                )

                // Actions
                TaskDetailActions(
                    
                    isCompleted: Binding(
                        
                        get: { task.isCompleted },
                        
                        set: { _ in
                            TaskRepository.toggleCompleted(task, context: context)
                        }
                    ),
                    
                    onEdit: { showEditSheet = true },
                    
                    onDelete: { showDeleteAlert = true }
                )

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showEditSheet) {
            
            // TODO: EditTaskView — reuse NewTaskView pre-filled
            Text("Edit Task — coming soon")
                .padding()
        }
        .alert("Delete Task", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                TaskRepository.deleteTask(task, context: context)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \"\(task.title)\"? This cannot be undone.")
        }
    }

    // MARK: - Computed strings

    private var notificationText: String {
        guard task.notificationsEnabled else { return "Notifications off" }
        
        let minutes = task.notifyBeforeMinutes
            
        return minutes > 0
            ? "Notify me \(Int(minutes).minutesToFriendlyString()) before"
            : "Notifications on"
    }

    private var repeatText: String {
        
        guard let rule = task.repeatRule, rule != "Does Not Repeat" else { return "Repeat: Never" }
        
        return "Repeat: \(rule)"
    }
}

// MARK: - Preview

#Preview {
    
    let context = PersistenceController.shared.container.viewContext
    
    let sample = TaskEntity(context: context)
    
    sample.id = UUID()
    sample.title = "Finish debugging code"
    sample.taskDescription = ""
    sample.category = "Work"
    sample.dueDate = Date().addingTimeInterval(3600)
    sample.notificationsEnabled = true
    sample.notifyBeforeMinutes = 60
    sample.repeatRule = "Does Not Repeat"
    sample.tags = ["Programming", "Easy"] as NSArray
    sample.isCompleted = false
    sample.isFavourite = false
    
    return NavigationStack {
        TaskDetailsView(task: sample).environment(\.managedObjectContext, context)
    }
}
