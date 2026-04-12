// Authored by ChatGPT on 2026-04-11

import SwiftUI

/// A simple root that shows SplashView briefly, then transitions to the main TasksView.
struct RootView: View {

    @Environment(\.managedObjectContext) private var context
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity.combined(with: .scale))
            } else {
                TasksView()
                    .environment(\.managedObjectContext, context)
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show splash for ~1.6s with a smooth fade
            withAnimation(.easeInOut(duration: 0.6)) {
                showSplash = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
