import SwiftUI

struct DiscoveryView: View {
    @ObservedObject var viewModel: EventsViewModel
    @EnvironmentObject var userService: UserService
    @State private var showCityPicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // City selector header
                    cityHeader

                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.filteredEvents.isEmpty {
                        emptyView
                    } else {
                        // Category filters
                        categoryFilters

                        // Time filters
                        timeFilters

                        // Events grouped by date
                        GroupedEventListView(groupedEvents: viewModel.groupedEvents)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Ontdek")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await viewModel.loadEvents(for: userService.currentUser.selectedCity)
            }
            .sheet(isPresented: $showCityPicker) {
                CityPickerView()
            }
        }
    }

    private var cityHeader: some View {
        Button {
            showCityPicker = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.accentColor)

                Text(userService.currentUser.selectedCity.name)
                    .font(.headline)

                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private var categoryFilters: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Categorieën")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                Spacer()

                if !viewModel.selectedCategories.isEmpty {
                    Button("Wis") {
                        viewModel.selectedCategories.removeAll()
                    }
                    .font(.caption)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(EventCategory.allCases) { category in
                        CategoryFilterChip(
                            category: category,
                            isSelected: viewModel.selectedCategories.contains(category)
                        ) {
                            viewModel.toggleCategory(category)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var timeFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(EventsViewModel.TimeFilter.allCases) { filter in
                    Button {
                        viewModel.setTimeFilter(filter)
                    } label: {
                        Text(filter.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedTimeFilter == filter
                                    ? Color.accentColor
                                    : Color(.systemGray6)
                            )
                            .foregroundStyle(
                                viewModel.selectedTimeFilter == filter
                                    ? .white
                                    : .primary
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Evenementen laden...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("Geen evenementen gevonden")
                .font(.headline)

            Text("Probeer andere filters of bekijk een andere stad")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if viewModel.hasActiveFilters {
                Button("Filters wissen") {
                    viewModel.clearFilters()
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal)
    }
}

#Preview {
    DiscoveryView(viewModel: EventsViewModel())
        .environmentObject(UserService.shared)
}
