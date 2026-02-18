// Authored by Jayden Lewis on 04/02/2026

import SwiftUI

struct TasksView: View {

    @EnvironmentObject var taskStore: TaskStore
    @State private var selectedCategory: String = "General"
    @State private var favouritesOnly: Bool = false
    @State private var sortAscending: Bool = true
    @State private var goToNewTask: Bool = false

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {



                    // Header
                    HStack {
                        Text("Tasks")
                            .font(.system(size: 40, weight: .bold))
                        Spacer()
                    }
                    
                    .padding(.horizontal, 20)
                    .padding(.top, 10)



                    // Category chips row
                    HStack(spacing: 10) {

                        // Favourites filter button
                        Button { favouritesOnly.toggle() } 
                        
                        label: {
                            
                            Image(systemName: favouritesOnly ? "star.fill" : "star")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 42, height: 42)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(categories, id: \.self) { category in
                                    
                                    // Using the CategoryChip component
                                    CategoryChip(
                                        title: category,
                                        isSelected: category == selectedCategory
                                    ) { selectedCategory = category }
                                }
                            }
                            
                            .padding(.vertical, 2)
                        }
                    }
                    
                    .padding(.horizontal, 20)



                    // Main card
                    VStack(spacing: 0) {

                        // Card header row
                        HStack {
                            
                            Text(selectedCategory)
                                .font(.system(size: 17, weight: .semibold))

                            Spacer()

                            Text("Date")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.secondary)

                            Button { sortAscending.toggle() } 
                            
                            label: {
                                Image(systemName: sortAscending ? "arrow.up.arrow.down" : "arrow.down.arrow.up")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.blue)
                            }

                            .padding(.leading, 2)

                            Button {
                
                                // TODO: list options 
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
                                
                                NavigationLink {
                                    
                                    TaskDetailsView(task: binding(for: task))
                                } label: {
                                    
                                    TaskRow(task: binding(for: task))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                .buttonStyle(.plain)

                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }

                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 6)
                    .padding(.horizontal, 20)

                    Spacer(minLength: 0)
                }

                // Floating search button (top-right)
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            
                            // TODO: search UI
                        } 
                        
                        label: {
                            
                            Image(systemName: "magnifyingglass")
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

                // Floating create button
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Button { goToNewTask = true } 
                        
                        label: {
                            
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
            .navigationDestination(isPresented: $goToNewTask) { NewTaskView() }
        }
    }
}



// Helpers
extension TasksView {

    private var categories: [String] {
        
        let cats = Set(taskStore.tasks.map { $0.category })
        let sorted = cats.sorted()

        if sorted.contains("General") {
            
            return ["General"] + sorted.filter { $0 != "General" }
        }

        if selectedCategory.isEmpty, let first = sorted.first {
            return [first] + sorted.dropFirst()
        }

        return sorted
    }

    private var filteredAndSortedTasks: [Task] {
        
        var result = taskStore.tasks

        // Ensure selectedCategory is valid
        if !categories.contains(selectedCategory), let first = categories.first {
            selectedCategory = first
        }

        // Filter by selected category
        result = result.filter { $0.category == selectedCategory }

        // Favourites filter
        if favouritesOnly {
            result = result.filter { $0.isFavourite }
        }

        // Sort by due date
        result.sort { a, b in
            sortAscending ? (a.dueDate < b.dueDate) : (a.dueDate > b.dueDate)
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



// Preview
struct TasksView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TasksView().environmentObject(TaskStore())
    }
}
