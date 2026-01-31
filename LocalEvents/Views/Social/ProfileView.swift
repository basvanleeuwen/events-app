import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userService: UserService
    @State private var showPrivacySettings = false

    var body: some View {
        NavigationStack {
            List {
                // Profile header
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Text(userService.currentUser.initials)
                                    .font(.title2)
                                    .fontWeight(.medium)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(userService.currentUser.name)
                                .font(.headline)

                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.caption)
                                Text(userService.currentUser.selectedCity.name)
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Stats
                Section("Jouw activiteit") {
                    HStack {
                        StatView(
                            count: userService.currentUser.goingEventIds.count,
                            label: "Evenementen"
                        )

                        Divider()

                        StatView(
                            count: userService.currentUser.interestedEventIds.count,
                            label: "Opgeslagen"
                        )

                        Divider()

                        StatView(
                            count: userService.friends.count,
                            label: "Vrienden"
                        )
                    }
                    .padding(.vertical, 8)
                }

                // Favorite categories
                Section("Favoriete categorieën") {
                    if userService.currentUser.favoriteCategories.isEmpty {
                        Text("Nog geen favorieten ingesteld")
                            .foregroundStyle(.secondary)
                    } else {
                        FlowLayout(spacing: 8) {
                            ForEach(userService.currentUser.favoriteCategories) { category in
                                CategoryBadge(category: category)
                            }
                        }
                    }
                }

                // Settings
                Section("Instellingen") {
                    NavigationLink {
                        PrivacySettingsView()
                    } label: {
                        Label("Privacy", systemImage: "hand.raised")
                    }

                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label("Meldingen", systemImage: "bell")
                    }

                    NavigationLink {
                        CityPickerView()
                    } label: {
                        Label("Stad wijzigen", systemImage: "location")
                    }
                }

                // About
                Section("Over Lokaal") {
                    Link(destination: URL(string: "https://example.com/about")!) {
                        Label("Over deze app", systemImage: "info.circle")
                    }

                    Link(destination: URL(string: "https://example.com/feedback")!) {
                        Label("Feedback geven", systemImage: "envelope")
                    }

                    HStack {
                        Text("Versie")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Profiel")
        }
    }
}

struct StatView: View {
    let count: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)

        for (index, subview) in subviews.enumerated() {
            let point = result.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > width && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }

            self.size.height = y + rowHeight
        }
    }
}

struct NotificationSettingsView: View {
    @State private var newEvents = true
    @State private var friendActivity = false
    @State private var eventReminders = true

    var body: some View {
        List {
            Section {
                Toggle("Nieuwe evenementen", isOn: $newEvents)
                Toggle("Vriend activiteit", isOn: $friendActivity)
                Toggle("Event herinneringen", isOn: $eventReminders)
            } header: {
                Text("Meldingen")
            } footer: {
                Text("Ontvang meldingen over evenementen die bij jou passen")
            }
        }
        .navigationTitle("Meldingen")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserService.shared)
}
