import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var circleScale: CGFloat = 0
    @State private var showRings = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            splashContent
                .onAppear {
                    animateSplash()
                }
        }
    }

    private var splashContent: some View {
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
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            Color.white.opacity(0.1 - Double(index) * 0.03),
                            lineWidth: 2
                        )
                        .frame(
                            width: showRings ? CGFloat(200 + index * 80) : 0,
                            height: showRings ? CGFloat(200 + index * 80) : 0
                        )
                        .animation(
                            .easeOut(duration: 1.2).delay(Double(index) * 0.15),
                            value: showRings
                        )
                }

                // Floating particles
                ForEach(0..<8) { index in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: CGFloat.random(in: 8...20))
                        .offset(
                            x: CGFloat.random(in: -150...150),
                            y: CGFloat.random(in: -200...200)
                        )
                        .scaleEffect(showRings ? 1 : 0)
                        .animation(
                            .easeOut(duration: 1).delay(Double(index) * 0.1),
                            value: showRings
                        )
                }
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

                    // Logo circle
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)

                    // Icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundStyle(.white)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }

                // App name
                VStack(spacing: 8) {
                    Text("Lokaal")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Ontdek wat er gebeurt")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
            }
        }
    }

    private func animateSplash() {
        // Animate logo
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            logoScale = 1
            logoOpacity = 1
            circleScale = 1
        }

        // Animate rings
        withAnimation(.easeOut(duration: 0.5)) {
            showRings = true
        }

        // Animate text
        withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
            textOffset = 0
            textOpacity = 1
        }

        // Transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(UserService.shared)
}
