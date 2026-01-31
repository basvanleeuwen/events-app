import Foundation

enum EventCategory: String, CaseIterable, Codable, Identifiable {
    case party = "Feest"
    case concert = "Concert"
    case culture = "Cultuur"
    case sport = "Sport"
    case food = "Food & Drink"
    case market = "Markt"
    case workshop = "Workshop"
    case outdoor = "Outdoor"
    case nightlife = "Uitgaan"
    case community = "Buurt"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .party: return "party.popper"
        case .concert: return "music.mic"
        case .culture: return "theatermasks"
        case .sport: return "sportscourt"
        case .food: return "fork.knife"
        case .market: return "bag"
        case .workshop: return "hammer"
        case .outdoor: return "leaf"
        case .nightlife: return "moon.stars"
        case .community: return "house.and.flag"
        }
    }

    var color: String {
        switch self {
        case .party: return "EventPurple"
        case .concert: return "EventPink"
        case .culture: return "EventOrange"
        case .sport: return "EventGreen"
        case .food: return "EventYellow"
        case .market: return "EventTeal"
        case .workshop: return "EventBlue"
        case .outdoor: return "EventGreen"
        case .nightlife: return "EventPurple"
        case .community: return "EventOrange"
        }
    }
}

struct Event: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let category: EventCategory
    let date: Date
    let endDate: Date?
    let location: EventLocation
    let imageURL: String?
    let price: EventPrice
    let organizer: String
    let websiteURL: String?
    let interestedCount: Int
    let goingCount: Int

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(date)
    }

    var isThisWeek: Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var isThisWeekend: Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return isThisWeek && (weekday == 7 || weekday == 1) // Saturday or Sunday
    }

    var formattedDate: String {
        if isToday {
            return "Vandaag"
        } else if isTomorrow {
            return "Morgen"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "nl_NL")
            formatter.dateFormat = "EEE d MMM"
            return formatter.string(from: date)
        }
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    var formattedDateFull: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct EventLocation: Codable, Equatable {
    let name: String
    let address: String
    let city: String
    let latitude: Double
    let longitude: Double
}

enum EventPrice: Codable, Equatable {
    case free
    case paid(amount: Double)
    case donation
    case unknown

    var displayText: String {
        switch self {
        case .free:
            return "Gratis"
        case .paid(let amount):
            if amount == amount.rounded() {
                return String(format: "€%.0f", amount)
            }
            return String(format: "€%.2f", amount)
        case .donation:
            return "Vrije donatie"
        case .unknown:
            return "Prijs onbekend"
        }
    }

    var isFree: Bool {
        if case .free = self { return true }
        return false
    }
}

extension Event {
    static let preview = Event(
        id: UUID(),
        title: "Koningsdag Festival",
        description: "Het grootste oranjefeest van de stad! Met live muziek, eten en drinken, en gezelligheid voor jong en oud.",
        category: .party,
        date: Date(),
        endDate: Date().addingTimeInterval(8 * 3600),
        location: EventLocation(
            name: "Museumplein",
            address: "Museumplein 1",
            city: "Amsterdam",
            latitude: 52.3579,
            longitude: 4.8813
        ),
        imageURL: nil,
        price: .free,
        organizer: "Gemeente Amsterdam",
        websiteURL: "https://koningsdag.amsterdam",
        interestedCount: 1247,
        goingCount: 523
    )
}
