import SwiftUI

struct CategoryBadge: View {
    let category: EventCategory
    var isSelected: Bool = false
    var showIcon: Bool = true
    var size: BadgeSize = .regular

    enum BadgeSize {
        case small, regular, large

        var iconSize: CGFloat {
            switch self {
            case .small: return 9
            case .regular: return 11
            case .large: return 14
            }
        }

        var textSize: CGFloat {
            switch self {
            case .small: return 10
            case .regular: return 12
            case .large: return 14
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .regular: return 12
            case .large: return 16
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return 4
            case .regular: return 6
            case .large: return 8
            }
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            if showIcon {
                Image(systemName: category.icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
            }
            Text(category.rawValue)
                .font(.system(size: size.textSize, weight: .semibold))
        }
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(
            Group {
                if isSelected {
                    LinearGradient(
                        colors: [categoryColor, categoryColorSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    categoryColor.opacity(0.12)
                }
            }
        )
        .foregroundStyle(isSelected ? .white : categoryColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(
                    isSelected ? Color.clear : categoryColor.opacity(0.2),
                    lineWidth: 1
                )
        )
    }

    private var categoryColor: Color {
        switch category {
        case .party: return Color(red: 0.6, green: 0.2, blue: 0.8)
        case .nightlife: return Color(red: 0.4, green: 0.2, blue: 0.7)
        case .concert: return Color(red: 0.9, green: 0.3, blue: 0.5)
        case .culture: return Color(red: 0.95, green: 0.5, blue: 0.2)
        case .sport: return Color(red: 0.2, green: 0.7, blue: 0.4)
        case .outdoor: return Color(red: 0.3, green: 0.75, blue: 0.55)
        case .food: return Color(red: 0.95, green: 0.6, blue: 0.1)
        case .market: return Color(red: 0.2, green: 0.7, blue: 0.7)
        case .workshop: return Color(red: 0.3, green: 0.5, blue: 0.9)
        case .community: return Color(red: 0.9, green: 0.45, blue: 0.35)
        }
    }

    private var categoryColorSecondary: Color {
        switch category {
        case .party: return Color(red: 0.8, green: 0.3, blue: 0.6)
        case .nightlife: return Color(red: 0.3, green: 0.1, blue: 0.5)
        case .concert: return Color(red: 0.95, green: 0.4, blue: 0.7)
        case .culture: return Color(red: 0.85, green: 0.35, blue: 0.25)
        case .sport: return Color(red: 0.15, green: 0.55, blue: 0.35)
        case .outdoor: return Color(red: 0.2, green: 0.6, blue: 0.5)
        case .food: return Color(red: 0.9, green: 0.4, blue: 0.15)
        case .market: return Color(red: 0.15, green: 0.55, blue: 0.6)
        case .workshop: return Color(red: 0.4, green: 0.35, blue: 0.85)
        case .community: return Color(red: 0.85, green: 0.35, blue: 0.4)
        }
    }
}

struct CategoryFilterChip: View {
    let category: EventCategory
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            CategoryBadge(category: category, isSelected: isSelected)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct CategoryFilterRow: View {
    @Binding var selectedCategories: Set<EventCategory>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(EventCategory.allCases) { category in
                    CategoryFilterChip(
                        category: category,
                        isSelected: selectedCategories.contains(category)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryCard: View {
    let category: EventCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [categoryColor, categoryColorSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)

                    Image(systemName: category.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                }

                Text(category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var categoryColor: Color {
        switch category {
        case .party: return Color(red: 0.6, green: 0.2, blue: 0.8)
        case .nightlife: return Color(red: 0.4, green: 0.2, blue: 0.7)
        case .concert: return Color(red: 0.9, green: 0.3, blue: 0.5)
        case .culture: return Color(red: 0.95, green: 0.5, blue: 0.2)
        case .sport: return Color(red: 0.2, green: 0.7, blue: 0.4)
        case .outdoor: return Color(red: 0.3, green: 0.75, blue: 0.55)
        case .food: return Color(red: 0.95, green: 0.6, blue: 0.1)
        case .market: return Color(red: 0.2, green: 0.7, blue: 0.7)
        case .workshop: return Color(red: 0.3, green: 0.5, blue: 0.9)
        case .community: return Color(red: 0.9, green: 0.45, blue: 0.35)
        }
    }

    private var categoryColorSecondary: Color {
        switch category {
        case .party: return Color(red: 0.8, green: 0.3, blue: 0.6)
        case .nightlife: return Color(red: 0.3, green: 0.1, blue: 0.5)
        case .concert: return Color(red: 0.95, green: 0.4, blue: 0.7)
        case .culture: return Color(red: 0.85, green: 0.35, blue: 0.25)
        case .sport: return Color(red: 0.15, green: 0.55, blue: 0.35)
        case .outdoor: return Color(red: 0.2, green: 0.6, blue: 0.5)
        case .food: return Color(red: 0.9, green: 0.4, blue: 0.15)
        case .market: return Color(red: 0.15, green: 0.55, blue: 0.6)
        case .workshop: return Color(red: 0.4, green: 0.35, blue: 0.85)
        case .community: return Color(red: 0.85, green: 0.35, blue: 0.4)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            CategoryBadge(category: .party)
            CategoryBadge(category: .concert, isSelected: true)
            CategoryBadge(category: .food, showIcon: false)
        }

        HStack {
            CategoryBadge(category: .sport, size: .small)
            CategoryBadge(category: .workshop, size: .regular)
            CategoryBadge(category: .culture, size: .large)
        }

        CategoryFilterRow(selectedCategories: .constant([.party, .concert]))

        HStack(spacing: 16) {
            CategoryCard(category: .party) {}
            CategoryCard(category: .concert) {}
            CategoryCard(category: .food) {}
        }
    }
    .padding()
}
