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

            TagChipsView(tags: tags)
        }
        
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}
