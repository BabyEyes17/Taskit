// Authored by Jayden Lewis on 07/02/2026

import SwiftUI

struct TaskDetailsView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskStore: TaskStore

    @Binding var task: Task

    @State private var goToEdit: Bool         = false
    @State private var showDeleteConfirm: Bool = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {

                // MARK: Back button
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

                // MARK: Title
                Text(task.title)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 4)

                // MARK: Detail card
                TaskDetailCard(
                    category: task.category,
                    description: task.description,
                    dueDateText: task.dueDate.formattedDueDate(),
                    notificationText: notificationText,
                    repeatText: repeatText,
                    tags: task.tags
                )

                // MARK: Actions
                TaskDetailActions(
                    isCompleted: $task.isCompleted,

                    onEdit: {
                        goToEdit = true
                    },

                    onDelete: {
                        showDeleteConfirm = true
                    }
                )

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
        }
        .navigationBarBackButtonHidden(true)
        // Navigate to edit form
        .navigationDestination(isPresented: $goToEdit) {
            NewTaskView(taskToEdit: task)
        }
        // Delete confirmation
        .confirmationDialog(
            "Delete "\(task.title)"?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                taskStore.delete(task)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This task will be permanently removed.")
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
    let store = TaskStore.preview
    return NavigationStack {
        TaskDetailsView(task: .constant(store.tasks[0]))
            .environmentObject(store)
    }
}
