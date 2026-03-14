// Authored by Jayden Lewis on 04/02/2026

import SwiftUI

struct TasksView: View {

    @EnvironmentObject var taskStore: TaskStore

    @State private var selectedCategory: String = "General"
    @State private var favouritesOnly: Bool     = false
    @State private var sortAscending: Bool       = true
    @State private var goToNewTask: Bool         = false
    @State private var showSearch: Bool          = false
    @State private var searchQuery: String       = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {

                    // MARK: Header
                    HStack {
                        Text("Tasks")
                            .font(.system(size: 40, weight: .bold))

                        Spacer()

                        // Search toggle
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showSearch.toggle()
                                if !showSearch { searchQuery = "" }
                            }
                        } label: {
                            Image(systemName: showSearch ? "xmark.circle.fill" : "magnifyingglass")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 38, height: 38)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // MARK: Search bar
                    if showSearch {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Search tasks…", text: $searchQuery)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // MARK: Category chips
                    HStack(spacing: 10) {
                        // Favourites filter
                        Button { favouritesOnly.toggle() } label: {
                            Image(systemName: favouritesOnly ? "star.fill" : "star")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(favouritesOnly ? .yellow : .secondary)
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

                    // MARK: Task card
                    VStack(spacing: 0) {

                        // Card header
                        HStack {
                            Text(selectedCategory)
                                .font(.system(size: 17, weight: .semibold))

                            Spacer()

                            Text("Date")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.secondary)

                            Button { sortAscending.toggle() } label: {
                                Image(systemName: sortAscending ? "arrow.up.arrow.down" : "arrow.down.arrow.up")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.blue)
                            }
                            .padding(.leading, 2)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                        Divider().padding(.leading, 16)

                        if filteredAndSortedTasks.isEmpty {
                            Text(emptyMessage)
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 36)
                                .frame(maxWidth: .infinity)
                        } else {
                            // MARK: Task rows with navigation
                            VStack(spacing: 0) {
                                ForEach(filteredAndSortedTasks) { task in
                                    NavigationLink(destination: TaskDetailsView(task: binding(for: task))) {
                                        TaskRow(task: binding(for: task))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                    }
                                    .buttonStyle(.plain)

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

                // MARK: Floating create button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button { goToNewTask = true } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 52, height: 52)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 8)
                        }
                        .padding(.trailing, 22)
                        .padding(.bottom, 22)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToNewTask) {
                NewTaskView()
            }
        }
    }
}

// MARK: - Helpers
extension TasksView {

    private var categories: [String] {
        let cats   = Set(taskStore.tasks.map { $0.category })
        let sorted = cats.sorted()
        if sorted.contains("General") {
            return ["General"] + sorted.filter { $0 != "General" }
        }
        return sorted
    }

    private var emptyMessage: String {
        if !searchQuery.isEmpty { return "No tasks match ";\(searchQuery);"" }
        if favouritesOnly       { return "No favourited tasks" }
        return "No tasks in \(selectedCategory)"
    }

    private var filteredAndSortedTasks: [Task] {
        var result = taskStore.tasks

        // Validate selected category
        if !categories.contains(selectedCategory), let first = categories.first {
            selectedCategory = first
        }

        result = result.filter { $0.category == selectedCategory }

        if favouritesOnly {
            result = result.filter { $0.isFavourite }
        }

        if !searchQuery.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery)
            }
        }

        result.sort { a, b in
            sortAscending ? a.dueDate < b.dueDate : a.dueDate > b.dueDate
        }

        return result
    }

    private func binding(for task: Task) -> Binding<Task> {
        guard let index = taskStore.tasks.firstIndex(where: { $0.id == task.id }) else {
            return .constant(task)
        }
        return $taskStore.tasks[index]
    }
}

// MARK: - Preview
#Preview {
    TasksView().environmentObject(TaskStore.preview)
}
