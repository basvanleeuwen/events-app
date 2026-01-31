import Foundation

actor EventService {
    static let shared = EventService()

    private init() {}

    func fetchEvents(for city: City, categories: [EventCategory]? = nil) async throws -> [Event] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        var events = Self.mockEvents.filter { $0.location.city == city.name }

        if let categories = categories, !categories.isEmpty {
            events = events.filter { categories.contains($0.category) }
        }

        return events.sorted { $0.date < $1.date }
    }

    func fetchEvent(id: UUID) async throws -> Event? {
        try await Task.sleep(nanoseconds: 200_000_000)
        return Self.mockEvents.first { $0.id == id }
    }

    func searchEvents(query: String, in city: City) async throws -> [Event] {
        try await Task.sleep(nanoseconds: 300_000_000)

        let lowercased = query.lowercased()
        return Self.mockEvents.filter { event in
            event.location.city == city.name &&
            (event.title.lowercased().contains(lowercased) ||
             event.description.lowercased().contains(lowercased) ||
             event.organizer.lowercased().contains(lowercased) ||
             event.location.name.lowercased().contains(lowercased))
        }
    }
}

extension EventService {
    static let mockEvents: [Event] = {
        let calendar = Calendar.current
        let now = Date()

        func date(daysFromNow: Int, hour: Int, minute: Int = 0) -> Date {
            let day = calendar.date(byAdding: .day, value: daysFromNow, to: now)!
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day)!
        }

        return [
            // Amsterdam Events
            Event(
                id: UUID(),
                title: "Vrijdagmiddagborrel @ Brouwerij 't IJ",
                description: "Sluit de week gezellig af met een speciaalbiertje bij de molen. Geen reservering nodig, gewoon langskomen!",
                category: .food,
                date: date(daysFromNow: 0, hour: 17),
                endDate: date(daysFromNow: 0, hour: 22),
                location: EventLocation(name: "Brouwerij 't IJ", address: "Funenkade 7", city: "Amsterdam", latitude: 52.3667, longitude: 4.9264),
                imageURL: nil,
                price: .free,
                organizer: "Brouwerij 't IJ",
                websiteURL: nil,
                interestedCount: 89,
                goingCount: 34
            ),
            Event(
                id: UUID(),
                title: "Open Mic Night",
                description: "Zin om te laten horen wat je kan? Of gewoon genieten van lokaal talent? Elke donderdag is het Open Mic Night in Cafe de Ceuvel.",
                category: .concert,
                date: date(daysFromNow: 1, hour: 20),
                endDate: date(daysFromNow: 1, hour: 23, minute: 30),
                location: EventLocation(name: "Cafe de Ceuvel", address: "Korte Papaverweg 4", city: "Amsterdam", latitude: 52.3914, longitude: 4.9124),
                imageURL: nil,
                price: .free,
                organizer: "Cafe de Ceuvel",
                websiteURL: nil,
                interestedCount: 156,
                goingCount: 67
            ),
            Event(
                id: UUID(),
                title: "Vondelpark Open Air Theatre",
                description: "Gratis voorstellingen in het hart van Amsterdam. Deze week: moderne dans door het Noord Nederlands Dans Collectief.",
                category: .culture,
                date: date(daysFromNow: 2, hour: 20, minute: 30),
                endDate: date(daysFromNow: 2, hour: 22),
                location: EventLocation(name: "Vondelpark Openluchttheater", address: "Vondelpark", city: "Amsterdam", latitude: 52.3579, longitude: 4.8663),
                imageURL: nil,
                price: .free,
                organizer: "Vondelpark Openluchttheater",
                websiteURL: nil,
                interestedCount: 412,
                goingCount: 198
            ),
            Event(
                id: UUID(),
                title: "Noordermarkt Boerenmarkt",
                description: "Elke zaterdag verse biologische producten, streekproducten en ambachtelijke lekkernijen op de gezellige Noordermarkt.",
                category: .market,
                date: date(daysFromNow: 3, hour: 9),
                endDate: date(daysFromNow: 3, hour: 16),
                location: EventLocation(name: "Noordermarkt", address: "Noordermarkt", city: "Amsterdam", latitude: 52.3803, longitude: 4.8847),
                imageURL: nil,
                price: .free,
                organizer: "Gemeente Amsterdam",
                websiteURL: nil,
                interestedCount: 234,
                goingCount: 89
            ),
            Event(
                id: UUID(),
                title: "Techno Sunday @ Shelter",
                description: "Duik de underground in bij Shelter Amsterdam. Line-up wordt 24 uur van tevoren bekendgemaakt.",
                category: .nightlife,
                date: date(daysFromNow: 4, hour: 23),
                endDate: date(daysFromNow: 5, hour: 8),
                location: EventLocation(name: "Shelter Amsterdam", address: "Overhoeksplein 3", city: "Amsterdam", latitude: 52.3843, longitude: 4.9012),
                imageURL: nil,
                price: .paid(amount: 20),
                organizer: "Shelter Amsterdam",
                websiteURL: nil,
                interestedCount: 567,
                goingCount: 234
            ),
            Event(
                id: UUID(),
                title: "Pottery Workshop voor Beginners",
                description: "Leer de basis van pottenbakken in deze relaxte workshop. Alle materialen inbegrepen, geen ervaring nodig.",
                category: .workshop,
                date: date(daysFromNow: 5, hour: 14),
                endDate: date(daysFromNow: 5, hour: 17),
                location: EventLocation(name: "Studio Klei", address: "KNSM-laan 291", city: "Amsterdam", latitude: 52.3784, longitude: 4.9456),
                imageURL: nil,
                price: .paid(amount: 45),
                organizer: "Studio Klei",
                websiteURL: nil,
                interestedCount: 23,
                goingCount: 8
            ),
            Event(
                id: UUID(),
                title: "Buurtbarbecue Oost",
                description: "Ken je buren! Neem wat te drinken mee en geniet van de gezelligheid. Vlees en vega opties aanwezig.",
                category: .community,
                date: date(daysFromNow: 6, hour: 16),
                endDate: date(daysFromNow: 6, hour: 21),
                location: EventLocation(name: "Oosterpark", address: "Oosterpark", city: "Amsterdam", latitude: 52.3601, longitude: 4.9214),
                imageURL: nil,
                price: .donation,
                organizer: "Buurtvereniging Oost",
                websiteURL: nil,
                interestedCount: 78,
                goingCount: 45
            ),
            Event(
                id: UUID(),
                title: "Bootcamp in het Vondelpark",
                description: "Start je zondag energiek! Gratis bootcamp voor alle niveaus. Breng je eigen matje mee.",
                category: .sport,
                date: date(daysFromNow: 7, hour: 9),
                endDate: date(daysFromNow: 7, hour: 10),
                location: EventLocation(name: "Vondelpark", address: "Vondelpark", city: "Amsterdam", latitude: 52.3579, longitude: 4.8686),
                imageURL: nil,
                price: .free,
                organizer: "Amsterdam Sports Club",
                websiteURL: nil,
                interestedCount: 134,
                goingCount: 67
            ),
            Event(
                id: UUID(),
                title: "Wandeling Amsterdamse Bos",
                description: "Ontdek de verborgen parels van het Amsterdamse Bos met een ervaren natuurgids. Inclusief koffie achteraf.",
                category: .outdoor,
                date: date(daysFromNow: 8, hour: 10),
                endDate: date(daysFromNow: 8, hour: 13),
                location: EventLocation(name: "Amsterdamse Bos", address: "Bosbaanweg", city: "Amsterdam", latitude: 52.3106, longitude: 4.8372),
                imageURL: nil,
                price: .paid(amount: 12.50),
                organizer: "Natuurmonumenten",
                websiteURL: nil,
                interestedCount: 45,
                goingCount: 23
            ),
            Event(
                id: UUID(),
                title: "Latin Party Night",
                description: "Salsa, bachata, reggaeton en meer! De beste Latin beats in de stad. Beginners welkom, gratis dansles om 22:00.",
                category: .party,
                date: date(daysFromNow: 9, hour: 22),
                endDate: date(daysFromNow: 10, hour: 4),
                location: EventLocation(name: "Club NYX", address: "Reguliersdwarsstraat 42", city: "Amsterdam", latitude: 52.3656, longitude: 4.8939),
                imageURL: nil,
                price: .paid(amount: 15),
                organizer: "Club NYX",
                websiteURL: nil,
                interestedCount: 345,
                goingCount: 156
            ),

            // Rotterdam Events
            Event(
                id: UUID(),
                title: "Fenix Food Factory",
                description: "Street food markt met de lekkerste hapjes uit Rotterdam en omstreken. Elke zondag op Katendrecht.",
                category: .food,
                date: date(daysFromNow: 1, hour: 12),
                endDate: date(daysFromNow: 1, hour: 18),
                location: EventLocation(name: "Fenix Food Factory", address: "Veerlaan 19D", city: "Rotterdam", latitude: 51.9010, longitude: 4.4869),
                imageURL: nil,
                price: .free,
                organizer: "Fenix Food Factory",
                websiteURL: nil,
                interestedCount: 456,
                goingCount: 234
            ),
            Event(
                id: UUID(),
                title: "Rotterdamse Dakendagen",
                description: "Ontdek Rotterdam van bovenaf! Tientallen daken zijn dit weekend open voor publiek.",
                category: .outdoor,
                date: date(daysFromNow: 3, hour: 10),
                endDate: date(daysFromNow: 3, hour: 18),
                location: EventLocation(name: "Diverse locaties", address: "Centrum Rotterdam", city: "Rotterdam", latitude: 51.9225, longitude: 4.4792),
                imageURL: nil,
                price: .paid(amount: 7.50),
                organizer: "Rotterdamse Dakendagen",
                websiteURL: nil,
                interestedCount: 789,
                goingCount: 345
            ),
            Event(
                id: UUID(),
                title: "Jazz @ De Doelen",
                description: "Internationaal jazz programma in een van de mooiste concertzalen van Nederland.",
                category: .concert,
                date: date(daysFromNow: 5, hour: 20, minute: 15),
                endDate: date(daysFromNow: 5, hour: 22, minute: 30),
                location: EventLocation(name: "De Doelen", address: "Schouwburgplein 50", city: "Rotterdam", latitude: 51.9209, longitude: 4.4747),
                imageURL: nil,
                price: .paid(amount: 35),
                organizer: "De Doelen",
                websiteURL: nil,
                interestedCount: 234,
                goingCount: 156
            ),

            // Utrecht Events
            Event(
                id: UUID(),
                title: "Terras aan de Werf",
                description: "Genieten van het mooie weer aan de Utrechtse grachten. Live akoestische muziek vanaf 16:00.",
                category: .food,
                date: date(daysFromNow: 0, hour: 14),
                endDate: date(daysFromNow: 0, hour: 22),
                location: EventLocation(name: "Werfdijk", address: "Oudegracht", city: "Utrecht", latitude: 52.0894, longitude: 5.1180),
                imageURL: nil,
                price: .free,
                organizer: "Cafe Olivier",
                websiteURL: nil,
                interestedCount: 167,
                goingCount: 78
            ),
            Event(
                id: UUID(),
                title: "Nacht van de Filosofie",
                description: "Een avond vol lezingen, debatten en gesprekken over de grote vragen des levens.",
                category: .culture,
                date: date(daysFromNow: 4, hour: 19),
                endDate: date(daysFromNow: 4, hour: 24),
                location: EventLocation(name: "TivoliVredenburg", address: "Vredenburgkade 11", city: "Utrecht", latitude: 52.0924, longitude: 5.1114),
                imageURL: nil,
                price: .paid(amount: 22.50),
                organizer: "Nacht van de Filosofie",
                websiteURL: nil,
                interestedCount: 567,
                goingCount: 289
            ),
            Event(
                id: UUID(),
                title: "Park Yoga Zondag",
                description: "Gratis yoga in het Wilhelminapark. Neem je eigen matje mee. Bij slecht weer: annulering via Instagram.",
                category: .sport,
                date: date(daysFromNow: 7, hour: 10),
                endDate: date(daysFromNow: 7, hour: 11, minute: 30),
                location: EventLocation(name: "Wilhelminapark", address: "Wilhelminapark", city: "Utrecht", latitude: 52.0847, longitude: 5.1342),
                imageURL: nil,
                price: .free,
                organizer: "Yoga Utrecht",
                websiteURL: nil,
                interestedCount: 89,
                goingCount: 45
            ),

            // Den Haag Events
            Event(
                id: UUID(),
                title: "Scheveningen Beach Cleanup",
                description: "Help mee het strand schoon te houden! Handschoenen en zakken worden verstrekt. Achteraf gratis koffie.",
                category: .community,
                date: date(daysFromNow: 2, hour: 10),
                endDate: date(daysFromNow: 2, hour: 12),
                location: EventLocation(name: "Scheveningen Strand", address: "Strandweg", city: "Den Haag", latitude: 52.1061, longitude: 4.2756),
                imageURL: nil,
                price: .free,
                organizer: "Ocean Cleanup Foundation",
                websiteURL: nil,
                interestedCount: 134,
                goingCount: 67
            ),
            Event(
                id: UUID(),
                title: "Escher in Het Paleis",
                description: "Laatste kans om de speciale Escher tentoonstelling te zien in het voormalige Winterpaleis.",
                category: .culture,
                date: date(daysFromNow: 1, hour: 10),
                endDate: date(daysFromNow: 1, hour: 17),
                location: EventLocation(name: "Escher in Het Paleis", address: "Lange Voorhout 74", city: "Den Haag", latitude: 52.0828, longitude: 4.3124),
                imageURL: nil,
                price: .paid(amount: 15.50),
                organizer: "Escher in Het Paleis",
                websiteURL: nil,
                interestedCount: 345,
                goingCount: 189
            ),

            // Eindhoven Events
            Event(
                id: UUID(),
                title: "Glow Festival Preview",
                description: "Sneak peek van dit jaar's lichtinstallaties. Rondleiding door de kunstenaars zelf.",
                category: .culture,
                date: date(daysFromNow: 6, hour: 19),
                endDate: date(daysFromNow: 6, hour: 22),
                location: EventLocation(name: "Stadswandelpark", address: "Stadswandelpark", city: "Eindhoven", latitude: 51.4360, longitude: 5.4737),
                imageURL: nil,
                price: .paid(amount: 12),
                organizer: "GLOW Eindhoven",
                websiteURL: nil,
                interestedCount: 678,
                goingCount: 234
            ),
            Event(
                id: UUID(),
                title: "Tech Meetup Eindhoven",
                description: "Maandelijkse meetup voor developers, designers en tech enthusiasts. Pizza & bier aanwezig!",
                category: .workshop,
                date: date(daysFromNow: 3, hour: 18, minute: 30),
                endDate: date(daysFromNow: 3, hour: 21, minute: 30),
                location: EventLocation(name: "High Tech Campus", address: "High Tech Campus 1", city: "Eindhoven", latitude: 51.4108, longitude: 5.4598),
                imageURL: nil,
                price: .free,
                organizer: "Tech Eindhoven",
                websiteURL: nil,
                interestedCount: 156,
                goingCount: 89
            ),

            // Groningen Events
            Event(
                id: UUID(),
                title: "Noorderzon Preview",
                description: "Voorproefje van het Noorderzon festival met gratis optredens in de stad.",
                category: .culture,
                date: date(daysFromNow: 5, hour: 16),
                endDate: date(daysFromNow: 5, hour: 23),
                location: EventLocation(name: "Noorderplantsoen", address: "Noorderplantsoen", city: "Groningen", latitude: 53.2240, longitude: 6.5552),
                imageURL: nil,
                price: .free,
                organizer: "Noorderzon",
                websiteURL: nil,
                interestedCount: 892,
                goingCount: 456
            ),
            Event(
                id: UUID(),
                title: "Studentenfeest Grote Markt",
                description: "Het semester is begonnen! Vier het mee op de Grote Markt met DJ's en live muziek.",
                category: .party,
                date: date(daysFromNow: 4, hour: 21),
                endDate: date(daysFromNow: 5, hour: 3),
                location: EventLocation(name: "Grote Markt", address: "Grote Markt", city: "Groningen", latitude: 53.2190, longitude: 6.5664),
                imageURL: nil,
                price: .free,
                organizer: "Gemeente Groningen",
                websiteURL: nil,
                interestedCount: 1234,
                goingCount: 567
            )
        ]
    }()
}
