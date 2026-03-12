// Authored by Jayden Lewis on 04/02/2026

import Foundation
import Combine

@MainActor
final class TaskStore: ObservableObject {

    static let preview: TaskStore = {
        
        let store = TaskStore()
        return store
    }()

    @Published var tasks: [Task] = [

        Task(
            title: "Organize desk",
            description: "Sort items on the desk and decide where everything should go for better workflow.",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),

        Task(
            title: "Read a few pages of your book",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),

        Task(
            title: "Check new work schedule",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 25)
        ),

        Task(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 26)
        ),

        Task(
            title: "Take notes during lecture",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 26)
        ),

        Task(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 27)
        ),

        Task(
            title: "Complete labs",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 27)
        ),

        Task(
            title: "Attend group meeting",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 27)
        ),

        Task(
            title: "Check email",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 28)
        ),

        Task(
            title: "Review feedback on assignments",
            category: "General",
            dueDate: makeDate(year: 2026, month: 1, day: 28)
        )
    ]
}

private func makeDate(year: Int, month: Int, day: Int) -> Date {
    
    var components = DateComponents()
    
    components.year = year
    components.month = month
    components.day = day
    components.hour = 9
    components.minute = 0

    return Calendar.current.date(from: components) ?? Date()
}
