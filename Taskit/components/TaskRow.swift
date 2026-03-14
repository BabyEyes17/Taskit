/// Authored by Jayden Lewis on 07/02/2026
// Displays a task formatted for a list row with navigation to the detail view.

import SwiftUI

struct TaskRow: View {

    @Binding var task: Task

    var body: some View {
        HStack(spacing: 12) {

            // MARK: Completion button
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            // MARK: Title and due date
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

            // MARK: Favourite button
            Button {
                task.isFavourite.toggle()
            } label: {
                Image(systemName: task.isFavourite ? "star.fill" : "star")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(task.isFavourite ? .yellow : .blue)
            }
            .buttonStyle(.plain)
        }
        .opacity(task.isCompleted ? 0.55 : 1.0)
    }
}

#Preview {
    let task = Task(
        title: "Organize desk",
        category: "General",
        dueDate: Date(),
        isFavourite: true
    )
    return TaskRow(task: .constant(task))
        .padding()
}
