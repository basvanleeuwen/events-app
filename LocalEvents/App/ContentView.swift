import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userService: UserService
    @StateObject private var viewModel = EventsViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoveryView(viewModel: viewModel)
                .tabItem {
                    Label("Ontdek", systemImage: "sparkles")
                }
                .tag(0)

            SearchView(viewModel: viewModel)
                .tabItem {
                    Label("Zoeken", systemImage: "magnifyingglass")
                }
                .tag(1)

            MyAgendaView(viewModel: viewModel)
                .tabItem {
                    Label("Mijn Agenda", systemImage: "calendar")
                }
                .tag(2)

            FriendsActivityView()
                .tabItem {
                    Label("Vrienden", systemImage: "person.2")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("Profiel", systemImage: "person.circle")
                }
                .tag(4)
        }
        .tint(.accentColor)
        .task {
            await viewModel.loadEvents(for: userService.currentUser.selectedCity)
        }
        .onChange(of: userService.currentUser.selectedCity) { _, newCity in
            Task {
                await viewModel.loadEvents(for: newCity)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserService.shared)
}
