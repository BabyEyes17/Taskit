// Authored by Jayden Lewis on 07/02/2026
// This component is called for displaying a task formatted for a VStack with minimal information.
// Supports navigation to the respective task's detailed view via NavigationLink.

import SwiftUI

struct TaskRow: View {

    @Binding var task: TaskItem

    var body: some View {

        NavigationLink(destination: TaskDetailsView(task: $task)) {

            HStack(spacing: 12) {

                // Completion button
                Button {
                    task.isCompleted.toggle()
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundStyle(task.isCompleted ? .green : .secondary)
                }
                .buttonStyle(.plain)

                // Title and due date
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
                Button {
                    task.isFavourite.toggle()
                } label: {
                    Image(systemName: task.isFavourite ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            .opacity(task.isCompleted ? 0.55 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    let store = TaskStore()
    return NavigationStack {
        TasksView()
    }
    .environmentObject(store)
}
