//  DeleteCategoryView.swift
//  Taskit
//
//  Created by Aidan Repchik on 2026-04-12.
//

import SwiftUI

struct CategoryDeleteView: View {

    @Binding var categories: [String]
    @Binding var selectedCategory: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {

            List {

                ForEach(categories, id: \.self) { category in

                    HStack {

                        Text(category)

                        Spacer()

                        Button {
                            delete(category)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Delete Categories")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func delete(_ category: String) {
        categories.removeAll { $0 == category }

        if !categories.contains(selectedCategory) {
            selectedCategory = categories.first ?? "General"
        }
    }
}
