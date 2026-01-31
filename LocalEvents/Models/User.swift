import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var avatarURL: String?
    var selectedCity: City
    var favoriteCategories: [EventCategory]
    var interestedEventIds: Set<UUID>
    var goingEventIds: Set<UUID>
    var friendIds: Set<UUID>
    var privacySettings: PrivacySettings

    var initials: String {
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

struct PrivacySettings: Codable, Equatable {
    var showInterestedToFriends: Bool
    var showGoingToFriends: Bool
    var allowFriendRequests: Bool
    var showInFriendsActivity: Bool

    static let `default` = PrivacySettings(
        showInterestedToFriends: true,
        showGoingToFriends: true,
        allowFriendRequests: true,
        showInFriendsActivity: true
    )

    static let private_ = PrivacySettings(
        showInterestedToFriends: false,
        showGoingToFriends: false,
        allowFriendRequests: false,
        showInFriendsActivity: false
    )
}

struct Friend: Identifiable, Equatable {
    let id: UUID
    let user: User
    var recentActivity: FriendActivity?
}

struct FriendActivity: Equatable {
    let event: Event
    let activityType: ActivityType
    let timestamp: Date

    enum ActivityType: String {
        case interested = "is geïnteresseerd in"
        case going = "gaat naar"
    }
}

extension User {
    static let preview = User(
        id: UUID(),
        name: "Jan de Vries",
        avatarURL: nil,
        selectedCity: .amsterdam,
        favoriteCategories: [.concert, .food, .culture],
        interestedEventIds: [],
        goingEventIds: [],
        friendIds: [],
        privacySettings: .default
    )

    static let previewFriends: [Friend] = [
        Friend(
            id: UUID(),
            user: User(
                id: UUID(),
                name: "Lisa Bakker",
                avatarURL: nil,
                selectedCity: .amsterdam,
                favoriteCategories: [.party, .nightlife],
                interestedEventIds: [],
                goingEventIds: [],
                friendIds: [],
                privacySettings: .default
            ),
            recentActivity: FriendActivity(
                event: .preview,
                activityType: .going,
                timestamp: Date().addingTimeInterval(-3600)
            )
        ),
        Friend(
            id: UUID(),
            user: User(
                id: UUID(),
                name: "Tom Hendriks",
                avatarURL: nil,
                selectedCity: .amsterdam,
                favoriteCategories: [.sport, .outdoor],
                interestedEventIds: [],
                goingEventIds: [],
                friendIds: [],
                privacySettings: .default
            ),
            recentActivity: nil
        )
    ]
}
