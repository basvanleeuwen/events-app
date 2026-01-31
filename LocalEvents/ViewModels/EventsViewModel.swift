import Foundation
import SwiftUI

@MainActor
class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var filteredEvents: [Event] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedCategories: Set<EventCategory> = []
    @Published var searchQuery = ""
    @Published var selectedTimeFilter: TimeFilter = .all

    private let eventService = EventService.shared

    enum TimeFilter: String, CaseIterable, Identifiable {
        case all = "Alles"
        case today = "Vandaag"
        case tomorrow = "Morgen"
        case thisWeek = "Deze week"
        case thisWeekend = "Weekend"

        var id: String { rawValue }
    }

    var groupedEvents: [(String, [Event])] {
        let calendar = Calendar.current
        var groups: [String: [Event]] = [:]

        for event in filteredEvents {
            let key: String
            if calendar.isDateInToday(event.date) {
                key = "Vandaag"
            } else if calendar.isDateInTomorrow(event.date) {
                key = "Morgen"
            } else if calendar.isDate(event.date, equalTo: Date(), toGranularity: .weekOfYear) {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "nl_NL")
                formatter.dateFormat = "EEEE"
                key = formatter.string(from: event.date).capitalized
            } else {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "nl_NL")
                formatter.dateFormat = "d MMMM"
                key = formatter.string(from: event.date)
            }

            groups[key, default: []].append(event)
        }

        // Sort groups by earliest event date
        return groups.sorted { group1, group2 in
            guard let date1 = group1.value.first?.date,
                  let date2 = group2.value.first?.date else {
                return false
            }
            return date1 < date2
        }
    }

    func loadEvents(for city: City) async {
        isLoading = true
        error = nil

        do {
            events = try await eventService.fetchEvents(for: city)
            applyFilters()
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func search(query: String, in city: City) async {
        guard !query.isEmpty else {
            applyFilters()
            return
        }

        isLoading = true

        do {
            let results = try await eventService.searchEvents(query: query, in: city)
            filteredEvents = results
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func toggleCategory(_ category: EventCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        applyFilters()
    }

    func setTimeFilter(_ filter: TimeFilter) {
        selectedTimeFilter = filter
        applyFilters()
    }

    func clearFilters() {
        selectedCategories.removeAll()
        selectedTimeFilter = .all
        searchQuery = ""
        applyFilters()
    }

    var hasActiveFilters: Bool {
        !selectedCategories.isEmpty || selectedTimeFilter != .all || !searchQuery.isEmpty
    }

    private func applyFilters() {
        var result = events

        // Apply category filter
        if !selectedCategories.isEmpty {
            result = result.filter { selectedCategories.contains($0.category) }
        }

        // Apply time filter
        switch selectedTimeFilter {
        case .all:
            break
        case .today:
            result = result.filter { $0.isToday }
        case .tomorrow:
            result = result.filter { $0.isTomorrow }
        case .thisWeek:
            result = result.filter { $0.isThisWeek }
        case .thisWeekend:
            result = result.filter { $0.isThisWeekend }
        }

        // Apply search query
        if !searchQuery.isEmpty {
            let query = searchQuery.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.description.lowercased().contains(query) ||
                $0.organizer.lowercased().contains(query) ||
                $0.location.name.lowercased().contains(query)
            }
        }

        filteredEvents = result
    }
}
