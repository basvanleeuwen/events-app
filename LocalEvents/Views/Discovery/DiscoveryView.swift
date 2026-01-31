import SwiftUI

struct DiscoveryView: View {
    @ObservedObject var viewModel: EventsViewModel
    @EnvironmentObject var userService: UserService
    @State private var showCityPicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero header
                    heroHeader
                        .padding(.bottom, 20)

                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.filteredEvents.isEmpty {
                        emptyView
                    } else {
                        VStack(alignment: .leading, spacing: 28) {
                            // Category carousel
                            categorySection

                            // Time filters
                            timeFiltersSection

                            // Events grouped by date
                            GroupedEventListView(groupedEvents: viewModel.groupedEvents)
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Lokaal")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
            }
            .refreshable {
                await viewModel.loadEvents(for: userService.currentUser.selectedCity)
            }
            .sheet(isPresented: $showCityPicker) {
                CityPickerView()
            }
        }
    }

    private var heroHeader: some View {
        VStack(spacing: 0) {
            // Gradient background
            ZStack(alignment: .bottomLeading) {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.3, blue: 0.9),
                        Color(red: 0.6, green: 0.2, blue: 0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 180)
                .overlay(
                    // Decorative circles
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 200, height: 200)
                            .offset(x: 150, y: -80)

                        Circle()
                            .fill(.white.opacity(0.08))
                            .frame(width: 100, height: 100)
                            .offset(x: -50, y: 60)

                        Circle()
                            .fill(.white.opacity(0.05))
                            .frame(width: 60, height: 60)
                            .offset(x: 100, y: 40)
                    }
                )

                // Content
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ontdek")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)

                    // City selector button
                    Button {
                        showCityPicker = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))

                            Text(userService.currentUser.selectedCity.name)
                                .font(.system(size: 16, weight: .semibold))

                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.2))
                        .background(.ultraThinMaterial.opacity(0.3))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(20)
                .padding(.bottom, 10)
            }
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Categorieën")
                    .font(.system(size: 20, weight: .bold))

                Spacer()

                if !viewModel.selectedCategories.isEmpty {
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedCategories.removeAll()
                        }
                    } label: {
                        Text("Wis filters")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(EventCategory.allCases) { category in
                        CategoryFilterChip(
                            category: category,
                            isSelected: viewModel.selectedCategories.contains(category)
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.toggleCategory(category)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var timeFiltersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(EventsViewModel.TimeFilter.allCases) { filter in
                    TimeFilterChip(
                        filter: filter,
                        isSelected: viewModel.selectedTimeFilter == filter
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.setTimeFilter(filter)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)

            Text("Evenementen laden...")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 100)

                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                Text("Geen evenementen gevonden")
                    .font(.system(size: 18, weight: .semibold))

                Text("Probeer andere filters of bekijk een andere stad")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if viewModel.hasActiveFilters {
                Button {
                    withAnimation {
                        viewModel.clearFilters()
                    }
                } label: {
                    Text("Filters wissen")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.4, green: 0.3, blue: 0.9), Color(red: 0.6, green: 0.2, blue: 0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 40)
    }
}

struct TimeFilterChip: View {
    let filter: EventsViewModel.TimeFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: filterIcon)
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(filter.rawValue)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [Color(red: 0.4, green: 0.3, blue: 0.9), Color(red: 0.6, green: 0.2, blue: 0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color(.systemBackground)
                    }
                }
            )
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .shadow(color: isSelected ? Color(red: 0.5, green: 0.3, blue: 0.85).opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var filterIcon: String {
        switch filter {
        case .all: return "sparkles"
        case .today: return "sun.max.fill"
        case .tomorrow: return "sunrise.fill"
        case .thisWeek: return "calendar"
        case .thisWeekend: return "party.popper.fill"
        }
    }
}

#Preview {
    DiscoveryView(viewModel: EventsViewModel())
        .environmentObject(UserService.shared)
}
