import SwiftUI

@main
struct LocalEventsApp: App {
    @StateObject private var userService = UserService.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showSplash = false
                        }
                    }
                } else if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .environmentObject(userService)
                } else {
                    ContentView()
                        .environmentObject(userService)
                }
            }
        }
    }
}

struct SplashScreenView: View {
    let onComplete: () -> Void

    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var circleScale: CGFloat = 0
    @State private var ringScales: [CGFloat] = [0, 0, 0]
    @State private var particleOpacity: Double = 0

    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.3, green: 0.2, blue: 0.8),
                    Color(red: 0.5, green: 0.2, blue: 0.7),
                    Color(red: 0.6, green: 0.3, blue: 0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative animated circles
            ZStack {
                // Outer rings
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(
                            Color.white.opacity(0.12 - Double(index) * 0.03),
                            lineWidth: 1.5
                        )
                        .frame(
                            width: CGFloat(200 + index * 100) * ringScales[index],
                            height: CGFloat(200 + index * 100) * ringScales[index]
                        )
                }

                // Floating particles
                FloatingParticlesView(opacity: particleOpacity)
            }

            // Main content
            VStack(spacing: 24) {
                // Logo
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(circleScale)

                    // Logo circle with glassmorphism
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.5), .white.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)

                    // Icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }

                // App name
                VStack(spacing: 8) {
                    Text("Lokaal")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Ontdek wat er gebeurt")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            animateSplash()
        }
    }

    private func animateSplash() {
        // Animate logo
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            logoScale = 1
            logoOpacity = 1
            circleScale = 1
        }

        // Animate rings with staggered delay
        for i in 0..<3 {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.7).delay(Double(i) * 0.15)) {
                ringScales[i] = 1
            }
        }

        // Animate particles
        withAnimation(.easeOut(duration: 1).delay(0.3)) {
            particleOpacity = 1
        }

        // Animate text
        withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
            textOffset = 0
            textOpacity = 1
        }

        // Transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            onComplete()
        }
    }
}

struct FloatingParticlesView: View {
    let opacity: Double

    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.25)))
                    .frame(width: CGFloat.random(in: 6...16))
                    .offset(
                        x: cos(Double(index) * .pi / 6) * CGFloat.random(in: 100...180),
                        y: sin(Double(index) * .pi / 6) * CGFloat.random(in: 100...180)
                    )
                    .opacity(opacity)
            }
        }
    }
}

#Preview {
    SplashScreenView(onComplete: {})
}
