import SwiftUI

struct EventCardView: View {
    let event: Event
    @EnvironmentObject var userService: UserService
    @State private var isPressed = false

    var isInterested: Bool {
        userService.isInterested(in: event.id)
    }

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero image area with gradient
            ZStack(alignment: .bottom) {
                // Background gradient
                Rectangle()
                    .fill(categoryGradient)
                    .frame(height: 140)
                    .overlay(
                        // Decorative pattern
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .offset(x: -60, y: -40)

                            Circle()
                                .fill(.white.opacity(0.08))
                                .frame(width: 60, height: 60)
                                .offset(x: 80, y: 20)

                            Image(systemName: event.category.icon)
                                .font(.system(size: 50, weight: .light))
                                .foregroundStyle(.white.opacity(0.2))
                                .offset(x: 50, y: -20)
                        }
                    )
                    .clipped()

                // Bottom gradient overlay for text readability
                LinearGradient(
                    colors: [.clear, .black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)

                // Date badge overlay
                HStack {
                    VStack(spacing: 2) {
                        Text(dayOfMonth)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text(monthAbbrev)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .textCase(.uppercase)
                    }
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .background(Color.white.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Spacer()

                    // Status indicator
                    if isGoing || isInterested {
                        statusIndicator
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(12)
            }

            // Content area
            VStack(alignment: .leading, spacing: 10) {
                // Category pill
                HStack(spacing: 6) {
                    Image(systemName: event.category.icon)
                        .font(.system(size: 10, weight: .semibold))
                    Text(event.category.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundStyle(categoryColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(categoryColor.opacity(0.12))
                .clipShape(Capsule())

                // Title
                Text(event.title)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Time
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(categoryColor.opacity(0.8))
                    Text(event.formattedTime)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                // Location
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(categoryColor.opacity(0.8))
                    Text(event.location.name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                // Divider
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 1)
                    .padding(.vertical, 4)

                // Bottom row: Price & Social proof
                HStack {
                    // Price tag
                    HStack(spacing: 4) {
                        if event.price.isFree {
                            Image(systemName: "gift.fill")
                                .font(.system(size: 12))
                        }
                        Text(event.price.displayText)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundStyle(event.price.isFree ? .green : .primary)

                    Spacer()

                    // Social proof
                    if event.goingCount > 0 || event.interestedCount > 0 {
                        HStack(spacing: 12) {
                            if event.goingCount > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.green)
                                    Text("\(event.goingCount)")
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                            if event.interestedCount > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.orange)
                                    Text("\(event.interestedCount)")
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(14)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: categoryColor.opacity(0.15), radius: 12, x: 0, y: 6)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }

    private var categoryGradient: LinearGradient {
        LinearGradient(
            colors: [categoryColor, categoryColorSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var categoryColor: Color {
        switch event.category {
        case .party: return Color(red: 0.6, green: 0.2, blue: 0.8)
        case .nightlife: return Color(red: 0.4, green: 0.2, blue: 0.7)
        case .concert: return Color(red: 0.9, green: 0.3, blue: 0.5)
        case .culture: return Color(red: 0.95, green: 0.5, blue: 0.2)
        case .sport: return Color(red: 0.2, green: 0.7, blue: 0.4)
        case .outdoor: return Color(red: 0.3, green: 0.75, blue: 0.55)
        case .food: return Color(red: 0.95, green: 0.6, blue: 0.1)
        case .market: return Color(red: 0.2, green: 0.7, blue: 0.7)
        case .workshop: return Color(red: 0.3, green: 0.5, blue: 0.9)
        case .community: return Color(red: 0.9, green: 0.45, blue: 0.35)
        }
    }

    private var categoryColorSecondary: Color {
        switch event.category {
        case .party: return Color(red: 0.8, green: 0.3, blue: 0.6)
        case .nightlife: return Color(red: 0.3, green: 0.1, blue: 0.5)
        case .concert: return Color(red: 0.95, green: 0.4, blue: 0.7)
        case .culture: return Color(red: 0.85, green: 0.35, blue: 0.25)
        case .sport: return Color(red: 0.15, green: 0.55, blue: 0.35)
        case .outdoor: return Color(red: 0.2, green: 0.6, blue: 0.5)
        case .food: return Color(red: 0.9, green: 0.4, blue: 0.15)
        case .market: return Color(red: 0.15, green: 0.55, blue: 0.6)
        case .workshop: return Color(red: 0.4, green: 0.35, blue: 0.85)
        case .community: return Color(red: 0.85, green: 0.35, blue: 0.4)
        }
    }

    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.date)
    }

    private var monthAbbrev: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.date)
    }

    @ViewBuilder
    private var statusIndicator: some View {
        if isGoing {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(.white)
                .shadow(color: .green.opacity(0.5), radius: 4, x: 0, y: 2)
        } else if isInterested {
            Image(systemName: "star.fill")
                .font(.system(size: 24))
                .foregroundStyle(.white)
                .shadow(color: .orange.opacity(0.5), radius: 4, x: 0, y: 2)
        }
    }
}

struct EventRowView: View {
    let event: Event
    @EnvironmentObject var userService: UserService

    var body: some View {
        HStack(spacing: 14) {
            // Date badge
            VStack(spacing: 1) {
                Text(dayOfMonth)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(monthAbbrev)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .textCase(.uppercase)
            }
            .foregroundStyle(categoryColor)
            .frame(width: 44, height: 44)
            .background(categoryColor.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(event.formattedTime)
                    }

                    Text("•")

                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 10))
                        Text(event.location.name)
                            .lineLimit(1)
                    }
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }

            Spacer()

            // Price badge
            Text(event.price.displayText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(event.price.isFree ? .green : .secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(event.price.isFree ? Color.green.opacity(0.1) : Color(.systemGray6))
                .clipShape(Capsule())

            // Quick action
            CompactInterestButton(event: event)
        }
        .padding(.vertical, 10)
    }

    private var categoryColor: Color {
        switch event.category {
        case .party: return Color(red: 0.6, green: 0.2, blue: 0.8)
        case .nightlife: return Color(red: 0.4, green: 0.2, blue: 0.7)
        case .concert: return Color(red: 0.9, green: 0.3, blue: 0.5)
        case .culture: return Color(red: 0.95, green: 0.5, blue: 0.2)
        case .sport: return Color(red: 0.2, green: 0.7, blue: 0.4)
        case .outdoor: return Color(red: 0.3, green: 0.75, blue: 0.55)
        case .food: return Color(red: 0.95, green: 0.6, blue: 0.1)
        case .market: return Color(red: 0.2, green: 0.7, blue: 0.7)
        case .workshop: return Color(red: 0.3, green: 0.5, blue: 0.9)
        case .community: return Color(red: 0.9, green: 0.45, blue: 0.35)
        }
    }

    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.date)
    }

    private var monthAbbrev: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.date)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            EventCardView(event: .preview)
                .padding(.horizontal)

            Divider()

            EventRowView(event: .preview)
                .padding(.horizontal)
        }
    }
    .environmentObject(UserService.shared)
}
