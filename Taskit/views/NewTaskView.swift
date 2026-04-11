// Authored by Aidan Repchik
// Integrated with TaskStore by Jayden Lewis on 08/02/2026
// Authored by Aidan Repchik
// Integrated with TaskStore by Jayden Lewis on 08/02/2026
// UI refresh — Jayden Lewis on 2026-04-11

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
    @State private var tags: [String]   = UserDefaults.standard.stringArray(forKey: "SavedTags") ?? ["Work", "School", "Personal"]
    @State private var selectedTags: [String] = []

    let notificationOptions = ["None", "5 Minutes Before", "15 Minutes Before", "30 Minutes Before", "1 Hour Before"]
    let repeatOptions       = ["Does Not Repeat", "Daily", "Weekly", "Monthly"]

    private var notificationsEnabled: Bool { notifyBefore != "None" }

    private var notifyBeforeMinutes: Int16 {
        switch notifyBefore {
        case "5 Minutes Before":  return 5
        case "15 Minutes Before": return 15
        case "30 Minutes Before": return 30
        case "1 Hour Before":     return 60
        default:                  return 0
        }
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {

        ZStack {

            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 0) {

                    // ── Header ───────────────────────────────────────────────
                    HStack {
                        Button { dismiss() } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundStyle(.blue)
                        }
                        Spacer()
                        Text("New Task")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        Button(action: createTask) {
                            Text("Add")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(isValid ? .blue : Color(.tertiaryLabel))
                        }
                        .disabled(!isValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    Text("New Task")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // ── Title & Description ──────────────────────────────────
                    FormSection {

                        FormRow {
                            TextField("Title", text: $title)
                                .font(.system(size: 16))
                        }

                        Divider().padding(.leading, 16)

                        FormRow {
                            TextField("Description", text: $description, axis: .vertical)
                                .lineLimit(3...5)
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.bottom, 16)

                    // ── Category ─────────────────────────────────────────────
                    FormSection {
                        FormRow {
                            Text("Category")
                                .font(.system(size: 16))
                                .foregroundStyle(.primary)
                            Spacer()
                            Picker("", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    .padding(.bottom, 16)

                    // ── Date & Time ──────────────────────────────────────────
                    FormSection {
                        FormRow {
                            DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                                .font(.system(size: 16))
                        }
                        Divider().padding(.leading, 16)
                        FormRow {
                            DatePicker("Time", selection: $dueDate, displayedComponents: [.hourAndMinute])
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.bottom, 16)

                    // ── Notifications & Repeat ───────────────────────────────
                    FormSection {
                        FormRow {
                            Text("Notify me")
                                .font(.system(size: 16))
                            Spacer()
                            Picker("", selection: $notifyBefore) {
                                ForEach(notificationOptions, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                        }
                        Divider().padding(.leading, 16)
                        FormRow {
                            Text("Repeat")
                                .font(.system(size: 16))
                            Spacer()
                            Picker("", selection: $repeatOption) {
                                ForEach(repeatOptions, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    .padding(.bottom, 16)

                    // ── Tags ─────────────────────────────────────────────────
                    FormSection {
                        NavigationLink(destination: TagSelectionView(tags: $tags, selectedTags: $selectedTags)) {
                            FormRow {
                                Text("Tags")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(selectedTags.isEmpty ? "None" : selectedTags.joined(separator: ", "))
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .lineLimit(1)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color(.tertiaryLabel))
                            }
                        }
                    }
                    .padding(.bottom, 24)

                    // ── Create button ────────────────────────────────────────
                    Button(action: createTask) {
                        Text("Create Task")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .foregroundStyle(.white)
                            .background(isValid ? Color.blue : Color.blue.opacity(0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(!isValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: tags) { newTags in
            UserDefaults.standard.set(newTags, forKey: "SavedTags")
        }
    }

    private func createTask() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let newTask = TaskRepository.addTask(
            title: trimmed,
            taskDescription: description,
            category: selectedCategory,
            dueDate: dueDate,
            notificationsEnabled: notificationsEnabled,
            notifyBeforeMinutes: notifyBeforeMinutes,
            repeatRule: repeatOption,
            tags: selectedTags,
            context: context
        )
        TaskRepository.scheduleNotification(for: newTask)
        dismiss()
    }
}

// MARK: - Shared form primitives

struct FormSection<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        VStack(spacing: 0) { content }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 20)
    }
}

struct FormRow<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        HStack { content }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NewTaskView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
