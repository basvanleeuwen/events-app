import Foundation
import SwiftUI

@MainActor
class UserService: ObservableObject {
    static let shared = UserService()

    @Published var currentUser: User
    @Published var friends: [Friend] = []
    @Published var friendsActivity: [FriendActivity] = []

    private init() {
        self.currentUser = User(
            id: UUID(),
            name: "Jij",
            avatarURL: nil,
            selectedCity: .amsterdam,
            favoriteCategories: [],
            interestedEventIds: [],
            goingEventIds: [],
            friendIds: [],
            privacySettings: .default
        )

        // Load demo friends
        self.friends = Self.demoFriends
        self.loadFriendsActivity()
    }

    // MARK: - Event Interest

    func isInterested(in eventId: UUID) -> Bool {
        currentUser.interestedEventIds.contains(eventId)
    }

    func isGoing(to eventId: UUID) -> Bool {
        currentUser.goingEventIds.contains(eventId)
    }

    func toggleInterested(eventId: UUID) {
        if currentUser.interestedEventIds.contains(eventId) {
            currentUser.interestedEventIds.remove(eventId)
        } else {
            currentUser.interestedEventIds.insert(eventId)
            // If marking as interested, remove from going
            currentUser.goingEventIds.remove(eventId)
        }
    }

    func toggleGoing(eventId: UUID) {
        if currentUser.goingEventIds.contains(eventId) {
            currentUser.goingEventIds.remove(eventId)
        } else {
            currentUser.goingEventIds.insert(eventId)
            // If going, also mark as interested
            currentUser.interestedEventIds.insert(eventId)
        }
    }

    // MARK: - City Selection

    func selectCity(_ city: City) {
        currentUser.selectedCity = city
    }

    // MARK: - Privacy

    func updatePrivacySettings(_ settings: PrivacySettings) {
        currentUser.privacySettings = settings
    }

    // MARK: - Friends

    func addFriend(_ user: User) {
        let friend = Friend(id: UUID(), user: user, recentActivity: nil)
        friends.append(friend)
        currentUser.friendIds.insert(user.id)
    }

    func removeFriend(_ friendId: UUID) {
        friends.removeAll { $0.id == friendId }
        currentUser.friendIds.remove(friendId)
    }

    private func loadFriendsActivity() {
        // Generate some demo activity
        friendsActivity = Self.demoActivity
    }

    // MARK: - Saved Events (My Agenda)

    func savedEvents(from allEvents: [Event]) -> [Event] {
        allEvents.filter { event in
            currentUser.goingEventIds.contains(event.id) ||
            currentUser.interestedEventIds.contains(event.id)
        }.sorted { $0.date < $1.date }
    }

    func goingEvents(from allEvents: [Event]) -> [Event] {
        allEvents.filter { currentUser.goingEventIds.contains($0.id) }
            .sorted { $0.date < $1.date }
    }

    func interestedEvents(from allEvents: [Event]) -> [Event] {
        allEvents.filter {
            currentUser.interestedEventIds.contains($0.id) &&
            !currentUser.goingEventIds.contains($0.id)
        }.sorted { $0.date < $1.date }
    }
}

extension UserService {
    static let demoFriends: [Friend] = {
        let events = EventService.mockEvents

        return [
            Friend(
                id: UUID(),
                user: User(
                    id: UUID(),
                    name: "Lisa Bakker",
                    avatarURL: nil,
                    selectedCity: .amsterdam,
                    favoriteCategories: [.party, .nightlife, .concert],
                    interestedEventIds: [],
                    goingEventIds: [],
                    friendIds: [],
                    privacySettings: .default
                ),
                recentActivity: events.first.map { event in
                    FriendActivity(event: event, activityType: .going, timestamp: Date().addingTimeInterval(-7200))
                }
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
                recentActivity: events.count > 3 ? FriendActivity(event: events[3], activityType: .interested, timestamp: Date().addingTimeInterval(-14400)) : nil
            ),
            Friend(
                id: UUID(),
                user: User(
                    id: UUID(),
                    name: "Emma de Jong",
                    avatarURL: nil,
                    selectedCity: .amsterdam,
                    favoriteCategories: [.culture, .workshop],
                    interestedEventIds: [],
                    goingEventIds: [],
                    friendIds: [],
                    privacySettings: PrivacySettings(
                        showInterestedToFriends: false,
                        showGoingToFriends: true,
                        allowFriendRequests: true,
                        showInFriendsActivity: false
                    )
                ),
                recentActivity: nil
            ),
            Friend(
                id: UUID(),
                user: User(
                    id: UUID(),
                    name: "Daan van Dijk",
                    avatarURL: nil,
                    selectedCity: .utrecht,
                    favoriteCategories: [.food, .market],
                    interestedEventIds: [],
                    goingEventIds: [],
                    friendIds: [],
                    privacySettings: .default
                ),
                recentActivity: events.count > 5 ? FriendActivity(event: events[5], activityType: .going, timestamp: Date().addingTimeInterval(-28800)) : nil
            )
        ]
    }()

    static let demoActivity: [FriendActivity] = {
        let events = EventService.mockEvents
        var activities: [FriendActivity] = []

        if events.count > 0 {
            activities.append(FriendActivity(event: events[0], activityType: .going, timestamp: Date().addingTimeInterval(-7200)))
        }
        if events.count > 2 {
            activities.append(FriendActivity(event: events[2], activityType: .interested, timestamp: Date().addingTimeInterval(-14400)))
        }
        if events.count > 4 {
            activities.append(FriendActivity(event: events[4], activityType: .going, timestamp: Date().addingTimeInterval(-28800)))
        }

        return activities
    }()
}
