// Authored by Aidan Repchik — updated by Jayden Lewis
// Supports both creating a new task and editing an existing one.

import SwiftUI

struct NewTaskView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskStore: TaskStore

    // Pass a task to pre-fill the form for editing; nil = create mode
    var taskToEdit: Task? = nil

    // MARK: - Form state
    @State private var title            = ""
    @State private var description      = ""
    @State private var selectedCategory = "General"
    @State private var dueDate          = Date()
    @State private var notifyEnabled    = false
    @State private var notifyMinutes    = 15
    @State private var repeatRule       = RepeatRule.none
    @State private var isFavourite      = false
    @State private var tags: [String]   = []
    @State private var tagDraft         = ""
    @State private var showTagField     = false

    // MARK: - Validation
    @State private var titleError = false

    private let categories     = ["General", "School", "Work", "Personal"]
    private let notifyOptions  = [5, 15, 30, 60]

    private var isEditing: Bool { taskToEdit != nil }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 242/255, green: 242/255, blue: 247/255).ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {

                        // MARK: Header
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

                            Button { isFavourite.toggle() } label: {
                                Image(systemName: isFavourite ? "star.fill" : "star")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(isFavourite ? .yellow : .secondary)
                            }
                        }
                        .padding(.horizontal, 20)

                        Text(isEditing ? "Edit Task" : "New Task")
                            .font(.system(size: 34, weight: .bold))
                            .padding(.horizontal, 20)

                        // MARK: Title
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Add Title", text: $title)
                                .font(.system(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(titleError ? Color.red.opacity(0.7) : Color.clear, lineWidth: 1.5)
                                )
                                .onChange(of: title) { _ in titleError = false }

                            if titleError {
                                Text("Title is required")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        .padding(.horizontal, 20)

                        // MARK: Category
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 20)

                        // MARK: Description
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                            .padding(.horizontal, 20)

                        // MARK: Due Date & Time
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                            .padding(.horizontal, 20)

                        DatePicker("Time", selection: $dueDate, displayedComponents: [.hourAndMinute])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                            .padding(.horizontal, 20)

                        // MARK: Notifications
                        VStack(spacing: 0) {
                            Toggle("Notifications", isOn: $notifyEnabled)
                                .padding()

                            if notifyEnabled {
                                Divider().padding(.leading, 16)

                                Picker("Notify me", selection: $notifyMinutes) {
                                    ForEach(notifyOptions, id: \.self) { min in
                                        Text(min.minutesToFriendlyString() + " before").tag(min)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)

                        // MARK: Repeat
                        Picker("Repeat", selection: $repeatRule) {
                            ForEach(RepeatRule.allCases) { rule in
                                Text(rule.rawValue).tag(rule)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 20)

                        // MARK: Tags
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Tags")
                                    .font(.system(size: 16))
                                Spacer()
                                Button {
                                    withAnimation { showTagField.toggle() }
                                } label: {
                                    Image(systemName: showTagField ? "minus.circle" : "plus.circle")
                                        .foregroundStyle(.blue)
                                }
                            }

                            if showTagField {
                                HStack {
                                    TextField("New tag…", text: $tagDraft)
                                        .font(.system(size: 15))
                                        .autocorrectionDisabled()
                                        .onSubmit { addTag() }

                                    Button("Add") { addTag() }
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(.blue)
                                }
                            }

                            if !tags.isEmpty {
                                FlowLayout(spacing: 8) {
                                    ForEach(tags, id: \.self) { tag in
                                        HStack(spacing: 4) {
                                            Text(tag)
                                                .font(.system(size: 14, weight: .medium))
                                            Button {
                                                tags.removeAll { $0 == tag }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 13))
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 10)
                                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    }
                                }
                            } else if !showTagField {
                                Text("No tags")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)

                        // MARK: Save button
                        Button(action: save) {
                            Text(isEditing ? "Save Changes" : "Create Task")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: .blue.opacity(0.25), radius: 10, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { prefill() }
    }

    // MARK: - Helpers

    private func prefill() {
        guard let t = taskToEdit else { return }
        title            = t.title
        description      = t.description
        selectedCategory = t.category
        dueDate          = t.dueDate
        notifyEnabled    = t.notificationsEnabled
        notifyMinutes    = t.notifyBeforeMinutes ?? 15
        repeatRule       = t.repeatRule
        isFavourite      = t.isFavourite
        tags             = t.tags
    }

    private func addTag() {
        let trimmed = tagDraft.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(trimmed) else { return }
        tags.append(trimmed)
        tagDraft = ""
    }

    private func save() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            titleError = true
            return
        }

        let updatedTask = Task(
            id: taskToEdit?.id ?? UUID(),
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            category: selectedCategory,
            dueDate: dueDate,
            notificationsEnabled: notifyEnabled,
            notifyBeforeMinutes: notifyEnabled ? notifyMinutes : nil,
            repeatRule: repeatRule,
            isCompleted: taskToEdit?.isCompleted ?? false,
            isFavourite: isFavourite,
            tags: tags
        )

        if isEditing {
            taskStore.update(updatedTask)
        } else {
            taskStore.add(updatedTask)
        }

        dismiss()
    }
}

// MARK: - Flow layout for tags

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { $0.size.height }.max() ?? 0 }.reduce(0) { $0 + $1 + spacing }
        return CGSize(width: proposal.width ?? 0, height: max(0, height - spacing))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: ProposedViewSize(width: bounds.width, height: nil), subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.size.height }.max() ?? 0
            for item in row {
                item.subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(item.size))
                x += item.size.width + spacing
            }
            y += rowHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[RowItem]] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [[RowItem]] = []
        var currentRow: [RowItem] = []
        var x: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = []
                x = 0
            }
            currentRow.append(RowItem(subview: subview, size: size))
            x += size.width + spacing
        }
        if !currentRow.isEmpty { rows.append(currentRow) }
        return rows
    }

    private struct RowItem {
        let subview: LayoutSubview
        let size: CGSize
    }
}

// MARK: - Preview
#Preview {
    NewTaskView().environmentObject(TaskStore.preview)
}
