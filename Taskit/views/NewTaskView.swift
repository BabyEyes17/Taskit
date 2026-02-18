// Authored by Aidan Repchik

import SwiftUI

struct NewTaskView: View {
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = "School"
    @State private var categories = ["School", "Work", "Personal"]
    @State private var dueDate = Date()
    @State private var notifyBefore = "15 Minutes Before"
    @State private var repeatOption = "Does Not Repeat"
    @State private var tags = ["No Tags Selected"]
    
    let notificationOptions = ["None", "5 Minutes Before", "15 Minutes Before", "1 Hour Before"]
    let repeatOptions = ["Does Not Repeat", "Daily", "Weekly", "Monthly"]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        
        NavigationStack{
            ZStack {
                
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {
                    
                    HStack {
                        
                        Button { dismiss() } label: {
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                                .frame(width: 36, height: 36)
                                .background(Color(.systemBackground).opacity(0.85))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                    }
                    
                
                    HStack {
                        Text("New Task")
                            .font(.system(size: 40, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Section {
                        TextField("Add Title", text: $title)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                            .accessibilityLabel("Task Title")
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                                    .font(.system(size: 16))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        TextField("description", text: $description)
                            .frame(height: 20)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                            .accessibilityLabel("Task Description")
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                        DatePicker("Time", selection: $dueDate, displayedComponents: [.hourAndMinute])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        Picker("Notify Me", selection: $notifyBefore) {
                            ForEach(notificationOptions, id: \.self) { option in
                                Text(option)
                                    .font(.system(size: 16))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        Picker("Repeat", selection: $repeatOption) {
                            ForEach(repeatOptions, id: \.self) { option in
                                Text(option)
                                    .font(.system(size: 16))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        NavigationLink(destination: Text("Tag selection screen")) {
                            HStack {
                                Text("Tags")
                                    .font(.system(size: 16))
                                Spacer()
                                Text(tags.joined(separator: ", "))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Section {
                        Button(action: createTask) {
                            Text("Create")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    func createTask() {
        print("Task Created:", title)
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
