// Authored by Jayden Lewis on 04/02/2026
// Hide/Show completed tasks added and Task search implimented by Aidan Repchik on 2026-03-16

// Authored by Jayden Lewis on 04/02/2026
// Hide/Show completed tasks added and Task search implemented by Aidan Repchik on 2026-03-16
// List options menu + UI polish by Jayden Lewis on 2026-04-11
// Authored by Jayden Lewis on 04/02/2026
// Hide/Show completed tasks added and Task search implemented by Aidan Repchik on 2026-03-16
// List options menu + UI polish by Jayden Lewis on 2026-04-11

import SwiftUI

enum TaskSortOption: String, CaseIterable {
    case date    = "Date"
    case title   = "Title"
    case category = "Category"
}

struct TasksView: View {

    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.dueDate, order: .forward)],
        animation: .default
    )

    private var tasks: FetchedResults<TaskEntity>

    @State private var selectedCategory : String  = "General"
    @State private var favouritesOnly   : Bool    = false
    @State private var sortAscending    : Bool    = true
    @State private var sortOption       : TaskSortOption = .date
    @State private var showNewTask      : Bool    = false
    @State private var searchText       : String  = ""
    @State private var showSearch       : Bool    = false
    @State private var showCompleted    : Bool    = true

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {

                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {

                    // ── Header row ───────────────────────────────────────────
                    HStack {

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tasks")
                                .font(.system(size: 40, weight: .bold))
                            if !tasks.isEmpty {
                                Text("\(filteredAndSortedTasks.count) task\(filteredAndSortedTasks.count == 1 ? "" : "s")")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        // Search toggle
                        Button {
                            withAnimation(.spring(response: 0.35)) { showSearch.toggle() }
                            if !showSearch { searchText = "" }
                        } label: {
                            Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(width: 42, height: 42)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // ── Search bar (animated) ────────────────────────────────
                    if showSearch {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Search tasks…", text: $searchText)
                                .font(.system(size: 16))
                            if !searchText.isEmpty {
                                Button { searchText = "" } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // ── Filter chip row ──────────────────────────────────────
                    HStack(spacing: 10) {

                        // Favourites filter
                        Button { withAnimation { favouritesOnly.toggle() } } label: {
                            Image(systemName: "star.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(favouritesOnly ? .blue : .gray)
                                .frame(width: 42, height: 42)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }

                        // Show/hide completed
                        Button { withAnimation { showCompleted.toggle() } } label: {
                            Image(systemName: showCompleted ? "eye" : "eye.slash")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(showCompleted ? .blue : .gray)
                                .frame(width: 42, height: 42)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(categories, id: \.self) { category in
                                    CategoryChip(
                                        title: category,
                                        isSelected: category == selectedCategory
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.horizontal, 20)

                    // ── Task list card ───────────────────────────────────────
                    VStack(spacing: 0) {

                        // Card header
                        HStack(spacing: 6) {

                            Text(selectedCategory)
                                .font(.system(size: 17, weight: .semibold))

                            Spacer()

                            // Current sort label
                            Text(sortOption.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)

                            // Sort direction toggle
                            Button { withAnimation { sortAscending.toggle() } } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.blue)
                                    .rotationEffect(.degrees(sortAscending ? 0 : 180))
                                    .animation(.easeInOut(duration: 0.2), value: sortAscending)
                            }

                            // ── List options menu (3 bars) ───────────────────
                            Menu {

                                // Sort by section
                                Section("Sort by") {
                                    ForEach(TaskSortOption.allCases, id: \.self) { option in
                                        Button {
                                            withAnimation { sortOption = option }
                                        } label: {
                                            Label(
                                                option.rawValue,
                                                systemImage: sortOption == option ? "checkmark" : sortOptionIcon(option)
                                            )
                                        }
                                    }
                                }

                                Divider()

                                // Display section
                                Section("Display") {
                                    Button {
                                        withAnimation { showCompleted.toggle() }
                                    } label: {
                                        Label(
                                            showCompleted ? "Hide Completed" : "Show Completed",
                                            systemImage: showCompleted ? "eye.slash" : "eye"
                                        )
                                    }

                                    Button {
                                        withAnimation { favouritesOnly.toggle() }
                                    } label: {
                                        Label(
                                            favouritesOnly ? "Show All Tasks" : "Favourites Only",
                                            systemImage: favouritesOnly ? "star.slash" : "star"
                                        )
                                    }
                                }

                                Divider()

                                // Sort direction
                                Section("Order") {
                                    Button {
                                        withAnimation { sortAscending = true }
                                    } label: {
                                        Label("Ascending", systemImage: sortAscending ? "checkmark" : "arrow.up")
                                    }
                                    Button {
                                        withAnimation { sortAscending = false }
                                    } label: {
                                        Label("Descending", systemImage: !sortAscending ? "checkmark" : "arrow.down")
                                    }
                                }

                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.blue)
                                    .frame(width: 28, height: 28)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                        Divider().padding(.leading, 16)

                        // Task rows / empty state
                        if filteredAndSortedTasks.isEmpty {
                            emptyStateView
                        } else {
                            VStack(spacing: 0) {
                                ForEach(filteredAndSortedTasks) { task in
                                    TaskRow(task: task)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                    Divider().padding(.leading, 16)
                                }
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 6)
                    .padding(.horizontal, 20)

                    Spacer(minLength: 0)
                }

                // ── Floating create button ───────────────────────────────────
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button { showNewTask = true } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.blue)
                                .frame(width: 52, height: 52)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .blue.opacity(0.18), radius: 14, x: 0, y: 8)
                        }
                        .padding(.trailing, 22)
                        .padding(.bottom, 22)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showNewTask) {
                NavigationStack {
                    NewTaskView()
                        .environment(\.managedObjectContext, context)
                }
            }
        }
    }

    // MARK: - Empty state

    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: favouritesOnly ? "star.slash" : "checkmark.circle")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text(favouritesOnly ? "No favourites yet" : "No tasks here")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
    }

    // MARK: - Sort option icon helper

    private func sortOptionIcon(_ option: TaskSortOption) -> String {
        switch option {
        case .date:     return "calendar"
        case .title:    return "textformat"
        case .category: return "list.bullet"
        }
    }
}

// MARK: - Helpers

extension TasksView {

    private var categories: [String] {
        let cats   = Set(tasks.compactMap { $0.category })
        let sorted = cats.sorted()
        if sorted.contains("General") {
            return ["General"] + sorted.filter { $0 != "General" }
        }
        return sorted
    }

    private var filteredAndSortedTasks: [TaskEntity] {

        var result = tasks.filter { $0.category == selectedCategory }

        if !categories.contains(selectedCategory), let first = categories.first {
            selectedCategory = first
        }

        if favouritesOnly {
            result = result.filter { $0.isFavourite }
        }

        if !showCompleted {
            result = result.filter { !$0.isCompleted }
        }

        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                ($0.title?.lowercased().contains(q) ?? false) ||
                ($0.taskDescription?.lowercased().contains(q) ?? false)
            }
        }

        // Sort
        return result.sorted { a, b in
            switch sortOption {
            case .date:
                guard let ad = a.dueDate, let bd = b.dueDate else { return false }
                return sortAscending ? ad < bd : ad > bd
            case .title:
                let at = a.title ?? ""
                let bt = b.title ?? ""
                return sortAscending ? at < bt : at > bt
            case .category:
                let ac = a.category ?? ""
                let bc = b.category ?? ""
                return sortAscending ? ac < bc : ac > bc
            }
        }
    }
}

// MARK: - Preview

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
