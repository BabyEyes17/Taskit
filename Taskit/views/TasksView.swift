// Authored by Jayden Lewis on 04/02/2026
// Hide/Show completed tasks added and Task search implimented by Aidan Repchik on 2026-03-16

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
    @State private var showCompleted: Bool = true

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {
               
                Color(.systemGroupedBackground).ignoresSafeArea()
               
                VStack(alignment: .leading, spacing: 14) {
                   
                    // MARK: - TasksView Header
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // MARK: - Search Bar
                    // (shown when toggled)
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

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tasks")
                            .font(.system(size: 40, weight: .bold))
                        if !tasks.isEmpty {
                            Text("\(filteredAndSortedTasks.count) task\(filteredAndSortedTasks.count == 1 ? "" : "s")")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)
                   
                    // MARK: - Category Chips
                    HStack(spacing: 10) {
                       
                        Button { withAnimation { favouritesOnly.toggle() } } label: {
                            Image(systemName: "star.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(favouritesOnly ? .blue : .gray)
                                .frame(width: 42, height: 42)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }
                        
                        // Show/Hide Completed button
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
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.blue)
                                    .rotationEffect(.degrees(sortAscending ? 0 : 180))
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


        if favouritesOnly {
            result = result.filter { $0.isFavourite }
        }


        if !showCompleted {
            result = result.filter { !$0.isCompleted }
        }


        // Filter by search text
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            let lowercasedSearch = searchText.lowercased()
            result = result.filter { task in
                (task.title?.lowercased().contains(lowercasedSearch) ?? false) ||
                (task.taskDescription?.lowercased().contains(lowercasedSearch) ?? false)
            }
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

