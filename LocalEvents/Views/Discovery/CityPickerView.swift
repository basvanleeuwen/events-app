import SwiftUI

struct CityPickerView: View {
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var filteredCities: [City] {
        City.search(searchText)
    }

    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section {
                        // Current location option
                        Button {
                            // Would request location permission and find nearest city
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.accentColor)
                                    .frame(width: 28)

                                VStack(alignment: .leading) {
                                    Text("Gebruik mijn locatie")
                                        .foregroundStyle(.primary)
                                    Text("Vind evenementen bij jou in de buurt")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                Section(searchText.isEmpty ? "Populaire steden" : "Resultaten") {
                    ForEach(filteredCities) { city in
                        CityRow(
                            city: city,
                            isSelected: city.id == userService.currentUser.selectedCity.id
                        ) {
                            userService.selectCity(city)
                            dismiss()
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Zoek stad...")
            .navigationTitle("Kies je stad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Klaar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CityRow: View {
    let city: City
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(city.name)
                        .font(.body)
                        .foregroundStyle(.primary)

                    Text(city.province)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accentColor)
                }
            }
        }
    }
}

#Preview {
    CityPickerView()
        .environmentObject(UserService.shared)
}
