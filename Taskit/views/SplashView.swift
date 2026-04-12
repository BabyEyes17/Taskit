// Authored by ChatGPT on 2026-04-11

import SwiftUI
import UIKit

struct SplashView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.11, green: 0.62, blue: 0.98), Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles (subtle)
            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 280, height: 280)
                .offset(x: 150, y: -220)
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 340, height: 340)
                .offset(x: -160, y: 260)

            VStack(spacing: 18) {
                // Prefer a provided asset named "TaskitSplash" if present, otherwise use a system mark
                if let uiImage = UIImage(named: "TaskitSplash") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)
                } else {
                    Image(systemName: "checkmark")
                        .font(.system(size: 88, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                }

                Text("TASKIT")
                    .font(.system(size: 32, weight: .heavy))
                    .kerning(1.2)
                    .foregroundStyle(.white)

                Divider()
                    .frame(width: 200)
                    .overlay(Color.white.opacity(0.35))
                    .padding(.vertical, 6)

                // Team members card
                VStack(spacing: 8) {
                    memberRow(name: "Sami Ar Rahman", id: "101488786")
                    memberRow(name: "Aidan Repchik", id: "101535819")
                    memberRow(name: "Jayden Lewis", id: "101484621")
                    memberRow(name: "Henil Patel", id: "101511850")
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Team members")
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
        }
        // Keep splash in light appearance to match brand artwork
        .preferredColorScheme(.light)
    }

    @ViewBuilder
    private func memberRow(name: String, id: String) -> some View {
        HStack(spacing: 6) {
            Text(name)
                .font(.system(size: 16, weight: .semibold))
            Text("- \(id)")
                .font(.system(size: 15))
                .opacity(0.9)
        }
        .foregroundStyle(.white)
        .accessibilityLabel("\(name), student number \(id)")
    }
}

#Preview {
    SplashView()
}
