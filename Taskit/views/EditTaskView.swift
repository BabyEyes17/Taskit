// UI refresh — Jayden Lewis on 2026-04-11

import SwiftUI
import CoreData

struct EditTaskView: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var task: TaskEntity

    @State private var title: String
    @State private var description: String
    @State private var selectedCategory: String
    @State private var categories: [String] = ["General", "School", "Work", "Personal"]
    @State private var dueDate: Date
    @State private var notifyBefore: String
    @State private var repeatOption: String
    @State private var tags: [String]
    @State private var selectedTags: [String]

    private let notificationOptions = ["None", "5 Minutes Before", "15 Minutes Before", "30 Minutes Before", "1 Hour Before"]
    private let repeatOptions       = ["Does Not Repeat", "Daily", "Weekly", "Monthly"]

    init(task: TaskEntity) {
        self._task             = ObservedObject(wrappedValue: task)
        self._title            = State(initialValue: task.title ?? "")
        self._description      = State(initialValue: task.taskDescription ?? "")
        self._selectedCategory = State(initialValue: task.category ?? "General")
        self._dueDate          = State(initialValue: task.dueDate ?? Date())
        self._notifyBefore     = State(initialValue: Self.notifyString(from: task.notifyBeforeMinutes, enabled: task.notificationsEnabled))
        self._repeatOption     = State(initialValue: task.repeatRule ?? "Does Not Repeat")
        self._tags             = State(initialValue: UserDefaults.standard.stringArray(forKey: "SavedTags") ?? ["Work", "School", "Personal"])
        self._selectedTags     = State(initialValue: (task.tags as? [String]) ?? [])
    }

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
                        Text("Edit Task")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        Button(action: saveChanges) {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(isValid ? .blue : Color(.tertiaryLabel))
                        }
                        .disabled(!isValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    Text("Edit Task")
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

                    // ── Save button ──────────────────────────────────────────
                    Button(action: saveChanges) {
                        Text("Save Changes")
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
    }

    private func saveChanges() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        TaskRepository.cancelNotification(for: task)
        task.title                = trimmed
        task.taskDescription      = description
        task.category             = selectedCategory
        task.dueDate              = dueDate
        task.notificationsEnabled = notificationsEnabled
        task.notifyBeforeMinutes  = notifyBeforeMinutes
        task.repeatRule           = repeatOption
        task.tags                 = selectedTags as NSArray
        TaskRepository.save(context: context)
        TaskRepository.scheduleNotification(for: task)
        dismiss()
    }

    private static func notifyString(from minutes: Int16, enabled: Bool) -> String {
        guard enabled else { return "None" }
        switch minutes {
        case 5:  return "5 Minutes Before"
        case 15: return "15 Minutes Before"
        case 30: return "30 Minutes Before"
        case 60: return "1 Hour Before"
        default: return "15 Minutes Before"
        }
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sample  = TaskEntity(context: context)
    sample.id                  = UUID()
    sample.title               = "Finish debugging code"
    sample.taskDescription     = "Fix the migration crash."
    sample.category            = "Work"
    sample.dueDate             = Date().addingTimeInterval(3600)
    sample.notificationsEnabled = true
    sample.notifyBeforeMinutes = 15
    sample.repeatRule          = "Does Not Repeat"
    sample.tags                = ["Swift", "iOS 26"] as NSArray
    return NavigationStack {
        EditTaskView(task: sample)
            .environment(\.managedObjectContext, context)
    }
}
