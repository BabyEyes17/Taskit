// Authored by Jayden Lewis on 07/02/2026
// TaskDetailsView.swift

import SwiftUI

struct TaskDetailsView: View {

    @EnvironmentObject var taskStore: TaskStore
    @Environment(\.dismiss) private var dismiss
    @Binding var task: TaskItem

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
                Text(task.title)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 4)

                // Detail card
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
                        showEditSheet = true
                    },
                    onDelete: {
                        showDeleteAlert = true
                    }
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
                taskStore.deleteTask(task)
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
        if let minutes = task.notifyBeforeMinutes {
            return "Notify me \(minutes.minutesToFriendlyString()) before"
        }
        return "Notifications on"
    }

    private var repeatText: String {
        task.repeatRule == .none
            ? "Repeat: Never"
            : "Repeat: \(task.repeatRule.rawValue)"
    }
}

// MARK: - Preview

#Preview {
    let store = TaskStore()
    @State var task = store.tasks[0]
    return NavigationStack {
        TaskDetailsView(task: $task)
            .environmentObject(store)
    }
}
