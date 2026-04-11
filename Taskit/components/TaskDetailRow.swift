// Authored by Jayden Lewis on 08/02/2026
// Authored by Jayden Lewis on 08/02/2026
// UI refresh — Jayden Lewis on 2026-04-11

import SwiftUI

struct TaskDetailRow: View {

    let icon: String
    let title: String
    var titleLineLimit: Int = 2
    var useSecondaryText: Bool = false
    var iconColor: Color = .blue

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            // Icon with tinted background
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(iconColor)
            }

            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(useSecondaryText ? Color(.secondaryLabel) : .primary)
                .lineLimit(titleLineLimit)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 7)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        TaskDetailRow(icon: "list.bullet", title: "General", iconColor: .blue)
        Divider().padding(.leading, 62)
        TaskDetailRow(icon: "text.alignleft", title: "No description", useSecondaryText: true, iconColor: .gray)
        Divider().padding(.leading, 62)
        TaskDetailRow(icon: "clock", title: "Sunday, January 25th - 9:00 AM", iconColor: .orange)
    }
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    .padding()
}
