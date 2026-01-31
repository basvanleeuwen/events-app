import SwiftUI

struct FriendsActivityView: View {
    @EnvironmentObject var userService: UserService
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab picker
                Picker("", selection: $selectedTab) {
                    Text("Activiteit").tag(0)
                    Text("Vrienden").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedTab == 0 {
                    activityFeed
                } else {
                    friendsList
                }
            }
            .navigationTitle("Vrienden")
        }
    }

    private var activityFeed: some View {
        Group {
            if userService.friends.isEmpty {
                emptyFriendsView
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        // Privacy notice - subtle and friendly
                        privacyNotice
                            .padding()

                        // Activity items
                        LazyVStack(spacing: 0) {
                            ForEach(activitiesWithFriends, id: \.0.id) { item in
                                FriendActivityRow(friend: item.0, activity: item.1)

                                Divider()
                                    .padding(.leading, 72)
                            }
                        }

                        if activitiesWithFriends.isEmpty {
                            noRecentActivityView
                                .padding(.vertical, 40)
                        }
                    }
                }
            }
        }
    }

    private var activitiesWithFriends: [(Friend, FriendActivity)] {
        userService.friends.compactMap { friend in
            guard let activity = friend.recentActivity,
                  friend.user.privacySettings.showInFriendsActivity else {
                return nil
            }
            return (friend, activity)
        }.sorted { $0.1.timestamp > $1.1.timestamp }
    }

    private var friendsList: some View {
        Group {
            if userService.friends.isEmpty {
                emptyFriendsView
            } else {
                List {
                    ForEach(userService.friends) { friend in
                        FriendRow(friend: friend)
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private var privacyNotice: some View {
        HStack(spacing: 12) {
            Image(systemName: "hand.raised.fill")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Jouw activiteit is privé")
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("Je vrienden zien alleen wat jij wilt delen")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            NavigationLink {
                PrivacySettingsView()
            } label: {
                Text("Instellingen")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var emptyFriendsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("Nog geen vrienden")
                    .font(.headline)

                Text("Voeg vrienden toe om te zien waar zij naartoe gaan")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                // Would show add friends flow
            } label: {
                HStack {
                    Image(systemName: "person.badge.plus")
                    Text("Vrienden toevoegen")
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var noRecentActivityView: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.title)
                .foregroundStyle(.secondary)

            Text("Geen recente activiteit")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct FriendActivityRow: View {
    let friend: Friend
    let activity: FriendActivity

    var body: some View {
        NavigationLink(destination: EventDetailView(event: activity.event)) {
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(friend.user.initials)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    // Activity text
                    Text(friend.user.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    +
                    Text(" \(activity.activityType.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Event title
                    Text(activity.event.title)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    // Time ago
                    Text(timeAgo(activity.timestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .buttonStyle(.plain)
    }

    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct FriendRow: View {
    let friend: Friend

    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(Color.accentColor.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(friend.user.initials)
                        .font(.subheadline)
                        .fontWeight(.medium)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.user.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(friend.user.selectedCity.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Privacy indicator
            if !friend.user.privacySettings.showInFriendsActivity {
                Image(systemName: "eye.slash")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PrivacySettingsView: View {
    @EnvironmentObject var userService: UserService

    var body: some View {
        List {
            Section {
                Toggle("Toon 'Interessant' aan vrienden", isOn: Binding(
                    get: { userService.currentUser.privacySettings.showInterestedToFriends },
                    set: { newValue in
                        var settings = userService.currentUser.privacySettings
                        settings.showInterestedToFriends = newValue
                        userService.updatePrivacySettings(settings)
                    }
                ))

                Toggle("Toon 'Ik ga' aan vrienden", isOn: Binding(
                    get: { userService.currentUser.privacySettings.showGoingToFriends },
                    set: { newValue in
                        var settings = userService.currentUser.privacySettings
                        settings.showGoingToFriends = newValue
                        userService.updatePrivacySettings(settings)
                    }
                ))

                Toggle("Verschijn in vrienden activiteit", isOn: Binding(
                    get: { userService.currentUser.privacySettings.showInFriendsActivity },
                    set: { newValue in
                        var settings = userService.currentUser.privacySettings
                        settings.showInFriendsActivity = newValue
                        userService.updatePrivacySettings(settings)
                    }
                ))
            } header: {
                Text("Wat vrienden kunnen zien")
            } footer: {
                Text("Je kunt altijd evenementen opslaan zonder dat anderen dit zien")
            }

            Section {
                Toggle("Vriendschapsverzoeken toestaan", isOn: Binding(
                    get: { userService.currentUser.privacySettings.allowFriendRequests },
                    set: { newValue in
                        var settings = userService.currentUser.privacySettings
                        settings.allowFriendRequests = newValue
                        userService.updatePrivacySettings(settings)
                    }
                ))
            } header: {
                Text("Wie kan jou vinden")
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FriendsActivityView()
        .environmentObject(UserService.shared)
}
