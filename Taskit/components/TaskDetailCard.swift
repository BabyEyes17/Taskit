// Authored by Jayden Lewis on 08/02/2026
// Authored by Jayden Lewis on 08/02/2026
// UI refresh — Jayden Lewis on 2026-04-11

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

            TaskDetailRow(icon: "list.bullet",      title: category,       iconColor: .blue)
            Divider().padding(.leading, 62)

            TaskDetailRow(
                icon: "text.alignleft",
                title: description.isEmpty ? "No description" : description,
                titleLineLimit: 4,
                useSecondaryText: description.isEmpty,
                iconColor: .purple
            )
            Divider().padding(.leading, 62)

            TaskDetailRow(icon: "clock",             title: dueDateText,    iconColor: .orange)
            Divider().padding(.leading, 62)

            TaskDetailRow(icon: "bell",              title: notificationText, iconColor: notificationText == "Notifications off" ? .gray : .green)
            Divider().padding(.leading, 62)

            TaskDetailRow(icon: "arrow.2.circlepath", title: repeatText,   iconColor: .teal)
            Divider().padding(.leading, 62)

            TagChipsView(tags: tags)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview {
    TaskDetailCard(
        category: "Work",
        description: "Sort items on the desk and decide where everything should go.",
        dueDateText: "Sunday, January 25th - 9:00 AM",
        notificationText: "Notify me 15 minutes before",
        repeatText: "Repeat: Never",
        tags: ["Swift", "iOS 26"]
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
