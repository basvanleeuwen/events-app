import SwiftUI

struct MyAgendaView: View {
    @ObservedObject var viewModel: EventsViewModel
    @EnvironmentObject var userService: UserService
    @State private var selectedFilter: AgendaFilter = .all

    enum AgendaFilter: String, CaseIterable, Identifiable {
        case all = "Alles"
        case going = "Ik ga"
        case interested = "Interessant"

        var id: String { rawValue }
    }

    var filteredEvents: [Event] {
        let allEvents = viewModel.events

        switch selectedFilter {
        case .all:
            return userService.savedEvents(from: allEvents)
        case .going:
            return userService.goingEvents(from: allEvents)
        case .interested:
            return userService.interestedEvents(from: allEvents)
        }
    }

    var upcomingEvents: [Event] {
        filteredEvents.filter { $0.date >= Date() }
    }

    var pastEvents: [Event] {
        filteredEvents.filter { $0.date < Date() }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter tabs
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(AgendaFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if filteredEvents.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Upcoming events
                            if !upcomingEvents.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Aankomend")
                                        .font(.headline)
                                        .padding(.horizontal)

                                    agendaEventsList(upcomingEvents)
                                }
                            }

                            // Past events
                            if !pastEvents.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Afgelopen")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal)

                                    agendaEventsList(pastEvents, isPast: true)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Mijn Agenda")
        }
    }

    private func agendaEventsList(_ events: [Event], isPast: Bool = false) -> some View {
        LazyVStack(spacing: 0) {
            ForEach(events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    AgendaEventRow(event: event, isPast: isPast)
                }
                .buttonStyle(.plain)

                if event.id != events.last?.id {
                    Divider()
                        .padding(.leading, 80)
                }
            }
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("Nog geen evenementen opgeslagen")
                    .font(.headline)

                Text("Markeer evenementen als 'Interessant' of 'Ik ga' om ze hier te zien")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AgendaEventRow: View {
    let event: Event
    var isPast: Bool = false
    @EnvironmentObject var userService: UserService

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Date badge
            VStack(spacing: 2) {
                Text(dayOfMonth)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(monthAbbreviation)
                    .font(.caption)
                    .textCase(.uppercase)
            }
            .foregroundStyle(isPast ? .secondary : .primary)
            .frame(width: 50)

            // Event info
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(isPast ? .secondary : .primary)

                HStack(spacing: 8) {
                    Text(event.formattedTime)
                    Text("•")
                    Text(event.location.name)
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            // Status indicator
            if isGoing {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)
            }
        }
        .padding(.vertical, 12)
        .opacity(isPast ? 0.7 : 1)
    }

    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.date)
    }

    private var monthAbbreviation: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.date)
    }
}

#Preview {
    MyAgendaView(viewModel: EventsViewModel())
        .environmentObject(UserService.shared)
}
