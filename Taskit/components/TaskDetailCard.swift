// Authored by Jayden Lewis on 08/02/2026

import SwiftUI

struct TaskDetailCard: View {

    let category: String
    let description: String
    let dueDateText: String
    let notificationText: String
    let repeatText: String
    let tags: [String]

    var body: some View {

        VStack(spacing: 0) {

            Group {
                TaskDetailRow(icon: "list.bullet", title: category)

                Divider().padding(.leading, 44)

                TaskDetailRow(
                    icon: "text.alignleft",
                    title: description.isEmpty ? "No description" : description,
                    titleLineLimit: 3,
                    useSecondaryText: description.isEmpty
                )

                Divider().padding(.leading, 44)

                TaskDetailRow(icon: "clock", title: dueDateText)

                Divider().padding(.leading, 44)

                TaskDetailRow(icon: "bell", title: notificationText)

                Divider().padding(.leading, 44)

                TaskDetailRow(icon: "arrow.2.circlepath", title: repeatText)

                Divider().padding(.leading, 44)
            }

            TagChipsView(tags: tags)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Preview

#Preview {
    TaskDetailCard(
        category: "General",
        description: "Sort items on the desk and decide where everything should go for better workflow.",
        dueDateText: "Sunday, January 25th - 9:00 AM",
        notificationText: "Notifications off",
        repeatText: "Repeat: Never",
        tags: ["Swift", "iOS 26"]
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
