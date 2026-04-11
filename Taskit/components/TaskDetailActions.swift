// Authored by Jayden Lewis on 08/02/2026
// Authored by Jayden Lewis on 08/02/2026
// UI refresh — Jayden Lewis on 2026-04-11

import SwiftUI

struct TaskDetailActions: View {

    @Binding var isCompleted: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {

        VStack(spacing: 10) {

            // Edit + Complete row
            HStack(spacing: 10) {

                ActionButton(
                    label: "Edit",
                    icon: "pencil",
                    color: .blue
                ) { onEdit() }

                ActionButton(
                    label: isCompleted ? "Incomplete" : "Complete",
                    icon: isCompleted ? "xmark.circle" : "checkmark.circle",
                    color: isCompleted ? .orange : .green
                ) { isCompleted.toggle() }
            }

            // Delete button
            ActionButton(
                label: "Delete Task",
                icon: "trash",
                color: .red,
                fullWidth: true
            ) { onDelete() }
        }
    }
}

// MARK: - Reusable action button

private struct ActionButton: View {

    let label: String
    let icon: String
    let color: Color
    var fullWidth: Bool = false
    let action: () -> Void

    var body: some View {

        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                Text(label)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(color)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: 50)
            .frame(maxWidth: fullWidth ? .infinity : .infinity)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

// MARK: - Preview

#Preview {
    TaskDetailActions(
        isCompleted: .constant(false),
        onEdit: {},
        onDelete: {}
    )
    .padding()
}
