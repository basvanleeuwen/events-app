import SwiftUI

struct EventDetailView: View {
    let event: Event
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header image
                headerImage

                VStack(alignment: .leading, spacing: 20) {
                    // Title and category
                    VStack(alignment: .leading, spacing: 8) {
                        CategoryBadge(category: event.category)

                        Text(event.title)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("door \(event.organizer)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Action buttons
                    InterestButton(event: event)

                    Divider()

                    // Event info
                    VStack(spacing: 16) {
                        // Date & Time
                        infoRow(
                            icon: "calendar",
                            title: event.formattedDateFull,
                            subtitle: event.formattedTime + (event.endDate != nil ? " - \(formatEndTime(event.endDate!))" : "")
                        )

                        // Location
                        infoRow(
                            icon: "mappin.circle.fill",
                            title: event.location.name,
                            subtitle: event.location.address + ", " + event.location.city
                        )

                        // Price
                        infoRow(
                            icon: "ticket.fill",
                            title: event.price.displayText,
                            subtitle: event.price.isFree ? "Geen ticket nodig" : "Ticket vereist"
                        )
                    }

                    Divider()

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Over dit evenement")
                            .font(.headline)

                        Text(event.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    // Social proof (subtle)
                    socialProofSection

                    // Website link
                    if let websiteURL = event.websiteURL, let url = URL(string: websiteURL) {
                        Divider()

                        Link(destination: url) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Meer informatie")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.accentColor)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private var headerImage: some View {
        ZStack {
            Rectangle()
                .fill(categoryGradient)
                .frame(height: 200)

            Image(systemName: event.category.icon)
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.3))
        }
    }

    private var categoryGradient: LinearGradient {
        let baseColor = categoryColor
        return LinearGradient(
            colors: [baseColor, baseColor.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var categoryColor: Color {
        switch event.category {
        case .party, .nightlife: return .purple
        case .concert: return .pink
        case .culture: return .orange
        case .sport, .outdoor: return .green
        case .food: return .yellow
        case .market: return .teal
        case .workshop: return .blue
        case .community: return .orange
        }
    }

    private func infoRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var socialProofSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Wie gaat er?")
                .font(.headline)

            HStack(spacing: 20) {
                // Going count
                VStack(spacing: 4) {
                    Text("\(event.goingCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    Text("gaan")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Interested count
                VStack(spacing: 4) {
                    Text("\(event.interestedCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                    Text("geïnteresseerd")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Friends going (if any)
            friendsGoingView
        }
    }

    @ViewBuilder
    private var friendsGoingView: some View {
        let friendsGoing = userService.friends.filter { friend in
            friend.recentActivity?.event.id == event.id
        }

        if !friendsGoing.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Divider()

                HStack(spacing: -8) {
                    ForEach(friendsGoing.prefix(3)) { friend in
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text(friend.user.initials)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemBackground), lineWidth: 2)
                            )
                    }
                }

                Text(friendsGoingText(friendsGoing.map { $0.user.name }))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)
        }
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
