// Authored by Jayden Lewis on 08/02/2026

import SwiftUI

struct TaskDetailActions: View {

    @Binding var isCompleted: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {

        VStack(spacing: 10) {

            HStack {

                Button { onEdit() } label: {
                    
                    Text("Edit").frame(maxWidth: .infinity)
                }

                Button { isCompleted.toggle() } label: {
                    
                    Text(isCompleted ? "Mark Incomplete" : "Mark Completed").frame(maxWidth: .infinity)
                }
            }
            
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.blue)

            Divider()

            Button { onDelete() } label: {
                
                Text("Delete")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
            }
            
            .padding(.top, 4)
        }
        
        .padding(.horizontal, 8)
    }
}
