import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "sparkles",
            iconColors: [Color(red: 0.5, green: 0.3, blue: 0.9), Color(red: 0.7, green: 0.3, blue: 0.8)],
            title: "Ontdek je stad",
            subtitle: "Vind de leukste evenementen, feestjes en activiteiten bij jou in de buurt",
            backgroundColors: [Color(red: 0.3, green: 0.2, blue: 0.7), Color(red: 0.5, green: 0.25, blue: 0.75)]
        ),
        OnboardingPage(
            icon: "calendar.badge.clock",
            iconColors: [Color(red: 0.9, green: 0.4, blue: 0.5), Color(red: 0.95, green: 0.5, blue: 0.6)],
            title: "Mis niks meer",
            subtitle: "Bewaar interessante events en bouw je persoonlijke agenda",
            backgroundColors: [Color(red: 0.8, green: 0.3, blue: 0.45), Color(red: 0.9, green: 0.4, blue: 0.55)]
        ),
        OnboardingPage(
            icon: "person.2.fill",
            iconColors: [Color(red: 0.2, green: 0.7, blue: 0.6), Color(red: 0.3, green: 0.8, blue: 0.7)],
            title: "Deel met vrienden",
            subtitle: "Zie waar je vrienden naartoe gaan — alleen als jij dat wilt",
            backgroundColors: [Color(red: 0.15, green: 0.6, blue: 0.55), Color(red: 0.25, green: 0.7, blue: 0.65)]
        )
    ]

    var body: some View {
        ZStack {
            // Animated background
            pages[currentPage].backgroundColors.first!
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentPage)

            // Background gradient overlay
            LinearGradient(
                colors: pages[currentPage].backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentPage)

            // Decorative elements
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .offset(x: geo.size.width * 0.3, y: -geo.size.height * 0.15)

                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 200, height: 200)
                        .offset(x: -geo.size.width * 0.4, y: geo.size.height * 0.3)

                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 150, height: 150)
                        .offset(x: geo.size.width * 0.2, y: geo.size.height * 0.35)
                }
            }

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button {
                            completeOnboarding()
                        } label: {
                            Text("Overslaan")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.trailing, 10)

                Spacer()

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Custom page indicator
                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(Color.white.opacity(index == currentPage ? 1 : 0.4))
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)

                // Action button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentPage += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text(currentPage < pages.count - 1 ? "Volgende" : "Aan de slag")
                            .font(.system(size: 18, weight: .bold))

                        Image(systemName: currentPage < pages.count - 1 ? "arrow.right" : "sparkles")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(pages[currentPage].backgroundColors.first!)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }

    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.3)) {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingPage {
    let icon: String
    let iconColors: [Color]
    let title: String
    let subtitle: String
    let backgroundColors: [Color]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOpacity: Double = 0
    @State private var textOpacity: Double = 0

    var body: some View {
        VStack(spacing: 40) {
            // Icon
            ZStack {
                // Glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 30,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                // Icon background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: page.iconColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: page.iconColors.first!.opacity(0.5), radius: 20, x: 0, y: 10)

                // Inner ring
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 120, height: 120)

                // Icon
                Image(systemName: page.icon)
                    .font(.system(size: 55, weight: .medium))
                    .foregroundStyle(.white)
            }
            .scaleEffect(iconScale)
            .opacity(iconOpacity)

            // Text
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            .opacity(textOpacity)
        }
        .padding(.bottom, 60)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconScale = 1
                iconOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                textOpacity = 1
            }
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
