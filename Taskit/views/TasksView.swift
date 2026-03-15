// Authored by Jayden Lewis on 04/02/2026

import SwiftUI

struct TasksView: View {

    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.dueDate, order: .forward)],
        animation: .default
    )
    
    private var tasks: FetchedResults<TaskEntity>
    
    @State private var selectedCategory: String = "General"
    @State private var favouritesOnly: Bool = false
    @State private var sortAscending: Bool = true
    @State private var showNewTask: Bool = false
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {

                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {

                    // ── Header ──────────────────────────────────────────────
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
                        
                        // MARK: - Floating Search Button
                        VStack {
                            HStack {
                                Spacer()
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
                                .padding(.trailing, 18)
                                .padding(.top, 10)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Search bar (shown when toggled)
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

                    // MARK: - Category Chips
                    HStack(spacing: 10) {

                        Button { withAnimation { favouritesOnly.toggle() } } label: {
                            Image(systemName: favouritesOnly ? "star.fill" : "star")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(favouritesOnly ? .yellow : .primary)
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

                    // MARK: Task List Card
                    VStack(spacing: 0) {

                        // Card header
                        HStack {
                            Text(selectedCategory)
                                .font(.system(size: 17, weight: .semibold))

                            Spacer()

                            Text("Date")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.secondary)

                            Button { withAnimation { sortAscending.toggle() } } label: {
                                Image(systemName: sortAscending ? "arrow.up.arrow.down" : "arrow.down.arrow.up")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.blue)
                            }
                            .padding(.leading, 2)

                            Button {
                
                                // TODO: List Sorting Options
                            }

                            label: {

                                Image(systemName: "line.3.horizontal")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.blue)
                            }
                            .padding(.leading, 6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                        Divider().padding(.leading, 16)

                        // Task rows
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

                // MARK: - Floating Create Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button { showNewTask = true } label: {
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
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showNewTask) {
                NewTaskView().environment(\.managedObjectContext, context)
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
}

// Helpers
extension TasksView {

    private var categories: [String] {
        
        let cats = Set(tasks.compactMap { $0.category })
        
        let sorted = cats.sorted()
        if sorted.contains("General") {
            return ["General"] + sorted.filter { $0 != "General" }
        }
        return sorted
    }

    private var filteredAndSortedTasks: [TaskEntity] {
        
        var result = tasks.filter { $0.category == selectedCategory }

        // Guard selected category
        if !categories.contains(selectedCategory), let first = categories.first {
            selectedCategory = first
        }

        result = result.filter { $0.category == selectedCategory }

        if favouritesOnly {
            result = result.filter { $0.isFavourite }
        }


        // Sort by due date
        return result.sorted {
            
            guard let a = $0.dueDate, let b = $1.dueDate else { return false }
            return sortAscending ? (a < b) : (a > b)
        }
    }
}

// Preview
struct TasksView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TasksView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
