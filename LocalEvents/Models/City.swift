import Foundation

struct City: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let province: String
    let latitude: Double
    let longitude: Double
    let radiusKm: Double

    var displayName: String {
        name
    }

    var fullName: String {
        "\(name), \(province)"
    }
}

extension City {
    static let amsterdam = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        name: "Amsterdam",
        province: "Noord-Holland",
        latitude: 52.3676,
        longitude: 4.9041,
        radiusKm: 15
    )

    static let rotterdam = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        name: "Rotterdam",
        province: "Zuid-Holland",
        latitude: 51.9244,
        longitude: 4.4777,
        radiusKm: 12
    )

    static let denHaag = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
        name: "Den Haag",
        province: "Zuid-Holland",
        latitude: 52.0705,
        longitude: 4.3007,
        radiusKm: 10
    )

    static let utrecht = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
        name: "Utrecht",
        province: "Utrecht",
        latitude: 52.0907,
        longitude: 5.1214,
        radiusKm: 10
    )

    static let eindhoven = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
        name: "Eindhoven",
        province: "Noord-Brabant",
        latitude: 51.4416,
        longitude: 5.4697,
        radiusKm: 10
    )

    static let groningen = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
        name: "Groningen",
        province: "Groningen",
        latitude: 53.2194,
        longitude: 6.5665,
        radiusKm: 10
    )

    static let tilburg = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
        name: "Tilburg",
        province: "Noord-Brabant",
        latitude: 51.5555,
        longitude: 5.0913,
        radiusKm: 8
    )

    static let almere = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
        name: "Almere",
        province: "Flevoland",
        latitude: 52.3508,
        longitude: 5.2647,
        radiusKm: 8
    )

    static let breda = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
        name: "Breda",
        province: "Noord-Brabant",
        latitude: 51.5719,
        longitude: 4.7683,
        radiusKm: 8
    )

    static let nijmegen = City(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!,
        name: "Nijmegen",
        province: "Gelderland",
        latitude: 51.8126,
        longitude: 5.8372,
        radiusKm: 8
    )

    static let allCities: [City] = [
        .amsterdam, .rotterdam, .denHaag, .utrecht, .eindhoven,
        .groningen, .tilburg, .almere, .breda, .nijmegen
    ]

    static func search(_ query: String) -> [City] {
        guard !query.isEmpty else { return allCities }
        let lowercased = query.lowercased()
        return allCities.filter { city in
            city.name.lowercased().contains(lowercased) ||
            city.province.lowercased().contains(lowercased)
        }
    }
}
