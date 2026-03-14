// Authored by Jayden Lewis on 04/02/2026

import Foundation
import Combine

@MainActor
final class TaskStore: ObservableObject {

    // MARK: - Shared preview instance
    static let preview: TaskStore = {
        let store = TaskStore()
        return store
    }()

    // MARK: - Persistence
    private let saveKey = "taskit_saved_tasks"

    @Published var tasks: [Task] = [] {
        didSet { saveTasks() }
    }

    init() {
        if let loaded = loadTasks(), !loaded.isEmpty {
            tasks = loaded
        } else {
            tasks = Self.seedTasks
        }
    }

    // MARK: - CRUD

    func add(_ task: Task) {
        tasks.append(task)
    }

    func update(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index] = task
    }

    func delete(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    func delete(at offsets: IndexSet, in filtered: [Task]) {
        let ids = offsets.map { filtered[$0].id }
        tasks.removeAll { ids.contains($0.id) }
    }

    // MARK: - Persistence helpers

    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadTasks() -> [Task]? {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Task].self, from: data)
        else { return nil }
        return decoded
    }

    // MARK: - Seed data

    private static var seedTasks: [Task] = [
        Task(
            title: "Organize desk",
            description: "Sort items on the desk and decide where everything should go for better workflow.",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),
        Task(
            title: "Read a few pages of your book",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25),
            isFavourite: true
        ),
        Task(
            title: "Check new work schedule",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25),
            notificationsEnabled: true,
            notifyBeforeMinutes: 15,
            repeatRule: .weekly
        ),
        Task(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 26),
            repeatRule: .daily
        ),
        Task(
            title: "Take notes during lecture",
            description: "Bring laptop and pen. Focus on key points.",
            category: "School",
            dueDate: makeDate(year: 2026, month: 1, day: 26),
            notificationsEnabled: true,
            notifyBeforeMinutes: 5,
            isFavourite: true,
            tags: ["lecture", "notes"]
        ),
        Task(
            title: "Complete labs",
            category: "School",
            dueDate: makeDate(year: 2026, month: 1, day: 27),
            tags: ["labs"]
        ),
        Task(
            title: "Attend group meeting",
            description: "Prepare slides before the meeting.",
            category: "Work",
            dueDate: makeDate(year: 2026, month: 1, day: 27),
            notificationsEnabled: true,
            notifyBeforeMinutes: 60,
            repeatRule: .weekly,
            isFavourite: true,
            tags: ["meetings"]
        ),
        Task(
            title: "Review feedback on assignments",
            category: "School",
            dueDate: makeDate(year: 2026, month: 1, day: 28)
        ),
        Task(
            title: "Gym session",
            description: "Upper body day. 45 mins.",
            category: "Personal",
            dueDate: makeDate(year: 2026, month: 1, day: 28, hour: 7),
            notificationsEnabled: true,
            notifyBeforeMinutes: 15,
            repeatRule: .daily,
            tags: ["fitness"]
        ),
        Task(
            title: "Grocery run",
            category: "Personal",
            dueDate: makeDate(year: 2026, month: 1, day: 29, hour: 11)
        )
    ]
}

// MARK: - Date helper

private func makeDate(year: Int, month: Int, day: Int, hour: Int = 9, minute: Int = 0) -> Date {
    var c = DateComponents()
    c.year = year; c.month = month; c.day = day
    c.hour = hour; c.minute = minute
    return Calendar.current.date(from: c) ?? Date()
}
