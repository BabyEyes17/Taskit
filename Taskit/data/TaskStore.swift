/// Authored by Jayden Lewis on 04/02/2026

import Foundation
import Combine

@MainActor
final class TaskStore: ObservableObject {

    static let preview: TaskStore = {
        let store = TaskStore()
        return store
    }()

    @Published var tasks: [TaskItem] = [

        TaskItem(
            title: "Organize desk",
            description: "Sort items on the desk and decide where everything should go for better workflow.",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),

        TaskItem(
            title: "Read a few pages of your book",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),

        TaskItem(
            title: "Check new work schedule",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),

        TaskItem(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 26)
        ),

        TaskItem(
            title: "Take notes during lecture",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 26)
        ),

        TaskItem(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 27)
        ),

        TaskItem(
            title: "Complete labs",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 27)
        ),

        TaskItem(
            title: "Attend group meeting",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 27)
        ),

        TaskItem(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 28)
        ),

        TaskItem(
            title: "Review feedback on assignments",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 28)
        )
    ]

    // MARK: - Mutating helpers

    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }

    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }

    func deleteTask(at offsets: IndexSet, in filtered: [TaskItem]) {
        let ids = offsets.map { filtered[$0].id }
        tasks.removeAll { ids.contains($0.id) }
    }
}

// MARK: - Private helpers

private func makeDate(year: Int, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = 9
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
}
