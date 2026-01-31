import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: EventsViewModel
    @EnvironmentObject var userService: UserService
    @State private var searchText = ""
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if searchText.isEmpty {
                    suggestionsView
                } else if viewModel.isLoading {
                    loadingView
                } else if viewModel.filteredEvents.isEmpty {
                    emptySearchView
                } else {
                    searchResultsView
                }
            }
            .navigationTitle("Zoeken")
            .searchable(
                text: $searchText,
                isPresented: $isSearching,
                prompt: "Zoek evenementen, locaties, artiesten..."
            )
            .onChange(of: searchText) { _, newValue in
                Task {
                    if newValue.isEmpty {
                        viewModel.searchQuery = ""
                        await viewModel.loadEvents(for: userService.currentUser.selectedCity)
                    } else {
                        viewModel.searchQuery = newValue
                        await viewModel.search(query: newValue, in: userService.currentUser.selectedCity)
                    }
                }
            }
        }
    }

    private var suggestionsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Popular categories
                VStack(alignment: .leading, spacing: 12) {
                    Text("Populaire categorieën")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(EventCategory.allCases.prefix(6)) { category in
                                CategorySuggestionCard(category: category) {
                                    searchText = category.rawValue
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Popular searches
                VStack(alignment: .leading, spacing: 12) {
                    Text("Populair in \(userService.currentUser.selectedCity.name)")
                        .font(.headline)
                        .padding(.horizontal)

                    VStack(spacing: 0) {
                        ForEach(popularSearches, id: \.self) { search in
                            Button {
                                searchText = search
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundStyle(.secondary)
                                    Text(search)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "arrow.up.left")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                            }

                            Divider()
                                .padding(.leading)
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                // This weekend quick filter
                VStack(alignment: .leading, spacing: 12) {
                    Text("Snel zoeken")
                        .font(.headline)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        QuickSearchChip(title: "Gratis", icon: "gift") {
                            searchText = "gratis"
                        }
                        QuickSearchChip(title: "Dit weekend", icon: "calendar") {
                            viewModel.setTimeFilter(.thisWeekend)
                        }
                        QuickSearchChip(title: "Vandaag", icon: "sun.max") {
                            viewModel.setTimeFilter(.today)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }

    private var searchResultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(viewModel.filteredEvents.count) resultaten")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                EventListView(events: viewModel.filteredEvents, title: nil, showAsCards: false)
            }
            .padding(.vertical)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Zoeken...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("Geen resultaten voor '\(searchText)'")
                .font(.headline)

            Text("Probeer andere zoekwoorden")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var popularSearches: [String] {
        [
            "Live muziek",
            "Food festival",
            "Gratis activiteiten",
            "Kunst & cultuur",
            "Markt"
        ]
    }
}

struct CategorySuggestionCard: View {
    let category: EventCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(categoryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
    }

    private var categoryColor: Color {
        switch category {
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

struct QuickSearchChip: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SearchView(viewModel: EventsViewModel())
        .environmentObject(UserService.shared)
}
