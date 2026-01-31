import SwiftUI

@main
struct LocalEventsApp: App {
    @StateObject private var userService = UserService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userService)
        }
    }
}
