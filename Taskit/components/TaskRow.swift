// Authored by Jayden Lewis on 07/02/2026
// This component is called for displaying a task formatted for a VStack with minimal information.
// Supports navigation to the respective task's detailed view via NavigationLink.
// Authored by Jayden Lewis on 07/02/2026
// UI refresh — Jayden Lewis on 2026-04-11

import SwiftUI
import CoreData

struct TaskRow: View {

    @Environment(\.managedObjectContext) private var context
    @ObservedObject var task: TaskEntity

    var body: some View {

        NavigationLink(destination: TaskDetailsView(task: task).environment(\.managedObjectContext, context)) {

            HStack(spacing: 14) {

                // Completion circle
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        TaskRepository.toggleCompleted(task, context: context)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .strokeBorder(task.isCompleted ? Color.green : Color(.tertiaryLabel), lineWidth: 1.5)
                            .frame(width: 26, height: 26)
                        if task.isCompleted {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 26, height: 26)
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .buttonStyle(.plain)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: task.isCompleted)

                // Title + metadata
                VStack(alignment: .leading, spacing: 5) {

                    Text(task.title ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .strikethrough(task.isCompleted, color: Color(.tertiaryLabel))
                        .foregroundStyle(task.isCompleted ? Color(.tertiaryLabel) : .primary)
                        .lineLimit(1)

                    HStack(spacing: 6) {

                        // Category pill
                        Text(task.category ?? "General")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())

                        // Due date
                        if let date = task.dueDate {
                            HStack(spacing: 3) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10, weight: .medium))
                                Text(date.formatted(using: .weekdayAbbrevMonthDay))
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(isOverdue(date) && !task.isCompleted
                                ? .red
                                : Color(.secondaryLabel))
                        }
                    }
                }

                Spacer(minLength: 0)

                // Favourite star
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        TaskRepository.toggleFavourite(task, context: context)
                    }
                } label: {
                    Image(systemName: task.isFavourite ? "star.fill" : "star")
                        .font(.system(size: 17))
                        .foregroundStyle(task.isFavourite ? .yellow : Color(.tertiaryLabel))
                        .scaleEffect(task.isFavourite ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3), value: task.isFavourite)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 2)
            .opacity(task.isCompleted ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
        }
        .buttonStyle(.plain)
    }

    private func isOverdue(_ date: Date) -> Bool {
        date < Calendar.current.startOfDay(for: Date())
    }
}
