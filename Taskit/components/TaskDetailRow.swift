// Authored by Jayden Lewis on 08/02/2026

import SwiftUI

struct TaskDetailRow: View {

    let icon: String
    let title: String
    var titleLineLimit: Int = 2
    var useSecondaryText: Bool = false

    var body: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24)

            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(useSecondaryText ? .secondary : .primary)
                .lineLimit(titleLineLimit)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        TaskDetailRow(icon: "list.bullet", title: "General")
        Divider().padding(.leading, 44)
        TaskDetailRow(icon: "text.alignleft", title: "No description", useSecondaryText: true)
        Divider().padding(.leading, 44)
        TaskDetailRow(icon: "clock", title: "Sunday, January 25th - 9:00 AM")
    }
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    .padding()
}
