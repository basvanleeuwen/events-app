import SwiftUI

struct EventCardView: View {
    let event: Event
    @EnvironmentObject var userService: UserService

    var isInterested: Bool {
        userService.isInterested(in: event.id)
    }

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder with category color
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(categoryGradient)
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: event.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.3))
                    )

                // Category badge
                CategoryBadge(category: event.category, showIcon: false)
                    .padding(12)

                // Status indicator
                if isGoing || isInterested {
                    HStack {
                        Spacer()
                        statusIndicator
                            .padding(12)
                    }
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)

                // Date & Time
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(event.formattedDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(event.formattedTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Location
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(event.location.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                // Bottom row: Price & Interest count
                HStack {
                    Text(event.price.displayText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(event.price.isFree ? .green : .primary)

                    Spacer()

                    if event.interestedCount > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.caption)
                            Text("\(event.interestedCount)")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
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

    @ViewBuilder
    private var statusIndicator: some View {
        if isGoing {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(6)
                .background(.green)
                .clipShape(Circle())
        } else if isInterested {
            Image(systemName: "star.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(6)
                .background(.orange)
                .clipShape(Circle())
        }
    }
}

struct EventRowView: View {
    let event: Event
    @EnvironmentObject var userService: UserService

    var body: some View {
        HStack(spacing: 12) {
            // Category color indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(categoryColor)
                .frame(width: 4)

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(event.formattedTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(event.location.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Price
            Text(event.price.displayText)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(event.price.isFree ? .green : .secondary)

            // Quick action
            CompactInterestButton(event: event)
        }
        .padding(.vertical, 8)
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
