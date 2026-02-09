// Authored by Jayden Lewis on 08/02/2026

import SwiftUI

struct TagChipsView: View {

    let tags: [String]

    private let columns: [GridItem] = [
        
        GridItem(.adaptive(minimum: 86), spacing: 8)
    ]

    var body: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: "tag")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24)

            if tags.isEmpty {

                Text("No tags")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)

            } 
            
            else {

                LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                    
                    ForEach(tags, id: \.self) { tag in
                        
                        Text(tag)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            }

            Spacer(minLength: 0)
        }
        
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}
