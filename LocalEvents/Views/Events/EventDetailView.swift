import SwiftUI

struct EventDetailView: View {
    let event: Event
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero header
                heroHeader

                // Content
                VStack(alignment: .leading, spacing: 24) {
                    // Title and category section
                    titleSection

                    // Action buttons
                    InterestButton(event: event)

                    // Quick info cards
                    quickInfoSection

                    // Description
                    descriptionSection

                    // Social proof
                    socialProofSection

                    // Website link
                    if let websiteURL = event.websiteURL, let url = URL(string: websiteURL) {
                        websiteLinkSection(url: url)
                    }
                }
                .padding(20)
                .background(Color(.systemBackground))
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack(alignment: .bottom) {
            // Background with illustration
            Rectangle()
                .fill(categoryGradient)
                .frame(height: 280)
                .overlay(
                    // Large category illustration
                    ZStack {
                        CategoryIllustration(category: event.category)

                        // Extra large icon
                        Image(systemName: event.category.icon)
                            .font(.system(size: 100, weight: .ultraLight))
                            .foregroundStyle(.white.opacity(0.12))
                            .offset(y: -20)
                    }
                )

            // Gradient overlay
            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )

            // Bottom content
            HStack(alignment: .bottom, spacing: 16) {
                // Date card
                VStack(spacing: 4) {
                    Text(dayOfWeek)
                        .font(.system(size: 11, weight: .bold))
                        .textCase(.uppercase)
                    Text(dayOfMonth)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text(monthAbbrev)
                        .font(.system(size: 13, weight: .bold))
                        .textCase(.uppercase)
                }
                .foregroundStyle(.white)
                .frame(width: 80, height: 100)
                .background(.ultraThinMaterial)
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                // Time badge
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                        Text(event.formattedTime)
                            .font(.system(size: 15, weight: .semibold))
                        if let endDate = event.endDate {
                            Text("- \(formatEndTime(endDate))")
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                    .foregroundStyle(.white)
                }

                Spacer()

                // Price badge
                Text(event.price.displayText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(event.price.isFree ? .green : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(event.price.isFree ? Color.green.opacity(0.2) : Color.white.opacity(0.2))
                    .background(.ultraThinMaterial.opacity(0.5))
                    .clipShape(Capsule())
            }
            .padding(20)
        }
    }

    // MARK: - Title Section

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category badge
            CategoryBadge(category: event.category, size: .large)

            // Title
            Text(event.title)
                .font(.system(size: 26, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)

            // Organizer
            HStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(categoryColor.opacity(0.6))

                Text("door ")
                    .foregroundStyle(.secondary)
                +
                Text(event.organizer)
                    .fontWeight(.medium)
            }
            .font(.system(size: 15))
        }
    }

    // MARK: - Quick Info Section

    private var quickInfoSection: some View {
        VStack(spacing: 12) {
            // Location card
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(categoryColor.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(categoryColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(event.location.name)
                        .font(.system(size: 16, weight: .semibold))
                    Text("\(event.location.address), \(event.location.city)")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // Date card
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(categoryColor.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: "calendar")
                        .font(.system(size: 22))
                        .foregroundStyle(categoryColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(event.formattedDateFull)
                        .font(.system(size: 16, weight: .semibold))
                    Text(timeRangeText)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var timeRangeText: String {
        if let endDate = event.endDate {
            return "\(event.formattedTime) - \(formatEndTime(endDate))"
        }
        return "Vanaf \(event.formattedTime)"
    }

    // MARK: - Description Section

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Over dit evenement")
                .font(.system(size: 18, weight: .bold))

            Text(event.description)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Social Proof Section

    private var socialProofSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wie gaat er?")
                .font(.system(size: 18, weight: .bold))

            HStack(spacing: 24) {
                // Going count
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.green)
                        Text("\(event.goingCount)")
                            .font(.system(size: 24, weight: .bold))
                    }
                    Text("gaan")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Interested count
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.orange)
                        Text("\(event.interestedCount)")
                            .font(.system(size: 24, weight: .bold))
                    }
                    Text("geïnteresseerd")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.orange.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            // Friends going
            friendsGoingView
        }
    }

    @ViewBuilder
    private var friendsGoingView: some View {
        let friendsGoing = userService.friends.filter { friend in
            friend.recentActivity?.event.id == event.id
        }

        if !friendsGoing.isEmpty {
            HStack(spacing: 12) {
                // Avatar stack
                HStack(spacing: -10) {
                    ForEach(friendsGoing.prefix(3)) { friend in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [categoryColor, categoryColorSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(friend.user.initials)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemBackground), lineWidth: 2)
                            )
                    }
                }

                Text(friendsGoingText(friendsGoing.map { $0.user.name }))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Website Link Section

    private func websiteLinkSection(url: URL) -> some View {
        Link(destination: url) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(categoryColor.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: "globe")
                        .font(.system(size: 20))
                        .foregroundStyle(categoryColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Meer informatie")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("Bezoek de website")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(categoryColor)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Helpers

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

    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "EEE"
        return formatter.string(from: event.date)
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

    private func friendsGoingText(_ names: [String]) -> String {
        switch names.count {
        case 1:
            return "\(names[0]) gaat ook"
        case 2:
            return "\(names[0]) en \(names[1]) gaan ook"
        default:
            return "\(names[0]) en \(names.count - 1) anderen gaan ook"
        }
    }

    private func formatEndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private var shareText: String {
        "\(event.title) - \(event.formattedDate) om \(event.formattedTime) @ \(event.location.name)"
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: .preview)
    }
    .environmentObject(UserService.shared)
}
