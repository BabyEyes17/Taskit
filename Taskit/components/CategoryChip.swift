// Authored by Jayden Lewis on 07/02/2026
// This component is called for displaying a formatted category chip

import SwiftUI

struct CategoryChip: View {
    
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        
        Button(action: onTap) {
            
            Text(title)
                
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isSelected ? .blue : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(isSelected ? Color.blue.opacity(0.15) : Color.clear, lineWidth: 1))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
        }
    }
}
