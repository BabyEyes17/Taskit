//  Created by Aidan Repchik on 2026-03-16.

import SwiftUI


struct TagSelectionView: View {
    @Binding var tags: [String]
    @Binding var selectedTags: [String]
    @State private var newTagName: String = ""
    @State private var showDeleteAlert = false
    @State private var tagToDelete: String?

    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        VStack {
            HStack {
                TextField("New tag", text: $newTagName)
                    .textFieldStyle(.roundedBorder)
                Button("Create Tag") {
                    addNewTag()
                }
                .disabled(newTagName.trimmingCharacters(in: .whitespaces).isEmpty || tags.contains(newTagName))
            }
            .padding()


            // List of tags
            List {
                ForEach(tags, id: \.self) { tag in
                    HStack {
                        Text(tag)
                        Spacer()
                        if selectedTags.contains(tag) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // Make entire row tappable
                    .onTapGesture {
                        toggle(tag)
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        tagToDelete = tags[index]
                        showDeleteAlert = true
                    }
                }
            }


            // Apply button
            Button("Apply") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .navigationTitle("Select Tags")
        .alert("Delete Tag?", isPresented: $showDeleteAlert, presenting: tagToDelete) { tag in
            Button("Delete", role: .destructive) {
                deleteTag(tag)
            }
            Button("Cancel", role: .cancel) {}
        } message: { tag in
            Text("Are you sure you want to delete the tag \"\(tag)\"?")
        }
    }


    // MARK: - Tag actions


    private func toggle(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
        } else {
            selectedTags.append(tag)
        }
    }


    private func addNewTag() {
        let trimmedTag = newTagName.trimmingCharacters(in: .whitespaces)
        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else { return }
        tags.append(trimmedTag)
        selectedTags.append(trimmedTag)
        newTagName = ""
    }


    private func deleteTag(_ tag: String) {
        tags.removeAll { $0 == tag }
        selectedTags.removeAll { $0 == tag }
    }
}
