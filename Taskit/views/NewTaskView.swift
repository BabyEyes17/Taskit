// Authored by Aidan Repchik
// Integrated with TaskStore by Jayden Lewis on 08/02/2026

import SwiftUI
import CoreData

struct NewTaskView: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title            = ""
    @State private var description      = ""
    @State private var selectedCategory = "General"
    @State private var categories       = ["General", "School", "Work", "Personal"]
    @State private var dueDate          = Date()
    @State private var notifyBefore     = "15 Minutes Before"
    @State private var repeatOption     = "Does Not Repeat"
    @State private var tags: [String]   = []

    let notificationOptions = ["None", "5 Minutes Before", "15 Minutes Before", "30 Minutes Before", "1 Hour Before"]
    let repeatOptions       = ["Does Not Repeat", "Daily", "Weekly", "Monthly"]

    // MARK: - Derived helpers

    private var notificationsEnabled: Bool {
        notifyBefore != "None"
    }

    private var notifyBeforeMinutes: Int16 {
        switch notifyBefore {
        case "5 Minutes Before":  return 5
        case "15 Minutes Before": return 15
        case "30 Minutes Before": return 30
        case "1 Hour Before":     return 60
        default:                  return 0
        }
    }

    private var repeatRule: String { repeatOption }

    // MARK: - Body

    var body: some View {

        ZStack {

            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 14) {

                    // Back button
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.85))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    // Heading
                    HStack {
                        Text("New Task")
                            .font(.system(size: 40, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Form card
                    VStack(alignment: .leading, spacing: 0) {

                        // Title
                        TextField("Add Title", text: $title)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            .accessibilityLabel("Task Title")

                        // Category picker
                        HStack {
                            Text("Category")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Picker("", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Description
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            .accessibilityLabel("Task Description")

                        // Due date + time
                        VStack(spacing: 0) {
                            DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                                .padding()
                            Divider().padding(.leading, 16)
                            DatePicker("Time", selection: $dueDate, displayedComponents: [.hourAndMinute])
                                .padding()
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Notify me
                        HStack {
                            Text("Notify me")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Picker("", selection: $notifyBefore) {
                                ForEach(notificationOptions, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Repeat
                        HStack {
                            Text("Repeat")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Picker("", selection: $repeatOption) {
                                ForEach(repeatOptions, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Tags placeholder
                        NavigationLink(destination: Text("Tag selection screen")) {
                            HStack {
                                Text("Tags")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(tags.isEmpty ? "No Tags Selected" : tags.joined(separator: ", "))
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 15))
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Create button
                        Button(action: createTask) {
                            Text("Create Task")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .padding()
                                .background(title.trimmingCharacters(in: .whitespaces).isEmpty ? Color.blue.opacity(0.4) : Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                        }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
                .padding(.top, 14)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Actions

    private func createTask() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        TaskRepository.addTask(
            title: trimmed,
            taskDescription: description,
            category: selectedCategory,
            dueDate: dueDate,
            notificationsEnabled: notificationsEnabled,
            notifyBeforeMinutes: notifyBeforeMinutes,
            repeatRule: repeatRule,
            tags: tags,
            context: context)
        
        dismiss()
    }
}

// Mark: - Preview
#Preview {
    NavigationStack {
        NewTaskView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
