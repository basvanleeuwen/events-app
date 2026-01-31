import SwiftUI

struct EventListView: View {
    let events: [Event]
    let title: String?
    var showAsCards: Bool = true

    var body: some View {
        if showAsCards {
            cardListView
        } else {
            rowListView
        }
    }

    private var cardListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventCardView(event: event)
                            .frame(width: 280)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    private var rowListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventRowView(event: event)
                }
                .buttonStyle(.plain)

                if event.id != events.last?.id {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct GroupedEventListView: View {
    let groupedEvents: [(String, [Event])]

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 24) {
            ForEach(groupedEvents, id: \.0) { group in
                VStack(alignment: .leading, spacing: 12) {
                    Text(group.0)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    EventListView(events: group.1, title: nil)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack(spacing: 32) {
                EventListView(events: [.preview], title: "Vandaag")
                EventListView(events: [.preview], title: nil, showAsCards: false)
            }
        }
    }
    .environmentObject(UserService.shared)
}
