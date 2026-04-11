// Authored by Jayden Lewis on 07/02/2026
// TaskDetailsView.swift
// Authored by Jayden Lewis on 07/02/2026
// UI refresh — Jayden Lewis on 2026-04-11
// Authored by Jayden Lewis on 07/02/2026
// UI refresh — Jayden Lewis on 2026-04-11

import SwiftUI
import CoreData

struct TaskDetailsView: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var task: TaskEntity

    @State private var showEditSheet   = false
    @State private var showDeleteAlert = false

    var body: some View {

        ZStack {

            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    // ── Nav bar ──────────────────────────────────────────────
                    HStack {
                        Button { dismiss() } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Tasks")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundStyle(.blue)
                        }
                        Spacer()

                        // Completion badge
                        if task.isCompleted {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 13))
                                Text("Done")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundStyle(.green)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.12))
                            .clipShape(Capsule())
                        }
                    }

                    // ── Hero section ─────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 8) {

                        Text(task.title ?? "Untitled")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(task.isCompleted ? Color(.secondaryLabel) : .primary)
                            .strikethrough(task.isCompleted, color: Color(.secondaryLabel))

                        // Metadata pills row
                        HStack(spacing: 8) {

                            Label(task.category ?? "General", systemImage: "list.bullet")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())

                            if let date = task.dueDate {
                                Label(shortDate(date), systemImage: "clock")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(isOverdue(date) && !task.isCompleted ? .red : Color(.secondaryLabel))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        (isOverdue(date) && !task.isCompleted ? Color.red : Color(.secondarySystemFill))
                                            .opacity(0.12)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    // ── Detail card ──────────────────────────────────────────
                    TaskDetailCard(
                        category: task.category ?? "General",
                        description: task.taskDescription ?? "",
                        dueDateText: task.dueDate?.formattedDueDate() ?? "No due date",
                        notificationText: notificationText,
                        repeatText: repeatText,
                        tags: task.tags as? [String] ?? []
                    )

                    // ── Actions ──────────────────────────────────────────────
                    TaskDetailActions(
                        isCompleted: Binding(
                            get: { task.isCompleted },
                            set: { _ in
                                withAnimation(.spring(response: 0.35)) {
                                    TaskRepository.toggleCompleted(task, context: context)
                                }
                            }
                        ),
                        onEdit:   { showEditSheet   = true },
                        onDelete: { showDeleteAlert = true }
                    )

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showEditSheet) {
            EditTaskView(task: task)
                .environment(\.managedObjectContext, context)
        }
        .alert("Delete Task", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                TaskRepository.cancelNotification(for: task)
                TaskRepository.deleteTask(task, context: context)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \"\(task.title ?? "this task")\"? This cannot be undone.")
        }
    }

    // MARK: - Helpers

    private var notificationText: String {
        guard task.notificationsEnabled else { return "Notifications off" }
        let m = Int(task.notifyBeforeMinutes)
        return m > 0 ? "Notify me \(m.minutesToFriendlyString()) before" : "Notifications on"
    }

    private var repeatText: String {
        guard let rule = task.repeatRule, rule != "Does Not Repeat" else { return "Repeat: Never" }
        return "Repeat: \(rule)"
    }

    private func shortDate(_ date: Date) -> String {
        date.formatted(using: .weekdayAbbrevMonthDay)
    }

    private func isOverdue(_ date: Date) -> Bool {
        date < Calendar.current.startOfDay(for: Date())
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sample = TaskEntity(context: context)
    sample.id = UUID()
    sample.title = "Finish debugging code"
    sample.taskDescription = "Fix the Core Data migration issue causing crashes on first launch."
    sample.category = "Work"
    sample.dueDate = Date().addingTimeInterval(3600)
    sample.notificationsEnabled = true
    sample.notifyBeforeMinutes = 15
    sample.repeatRule = "Does Not Repeat"
    sample.tags = ["Swift", "iOS 26"] as NSArray
    sample.isCompleted = false
    sample.isFavourite = true

    return NavigationStack {
        TaskDetailsView(task: sample)
            .environment(\.managedObjectContext, context)
    }
}
