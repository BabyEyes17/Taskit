//
//  RootView.swift
//  Taskit
//
//  Created by Sami Ar Rahman on 2026-04-14.
//

import Foundation
import SwiftUI

/// A simple root that shows SplashView briefly, then transitions to the main TasksView.
struct RootView: View {

    @Environment(\.managedObjectContext) private var context
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .ignoresSafeArea()
                    .transition(.opacity.combined(with: .scale))
            } else {
                TasksView()
                    .environment(\.managedObjectContext, context)
                    .transition(.opacity)
            }
        }
        .task {
            // Show splash briefly, then transition to TasksView
            showSplash = true
            try? await Task.sleep(nanoseconds: 1_600_000_000)
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}

#Preview {
    RootView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
