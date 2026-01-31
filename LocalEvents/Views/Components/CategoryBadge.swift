import SwiftUI

struct CategoryBadge: View {
    let category: EventCategory
    var isSelected: Bool = false
    var showIcon: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            if showIcon {
                Image(systemName: category.icon)
                    .font(.caption2)
            }
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            isSelected
                ? Color.accentColor
                : Color(.systemGray5)
        )
        .foregroundStyle(isSelected ? .white : .primary)
        .clipShape(Capsule())
    }
}

struct CategoryFilterChip: View {
    let category: EventCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            CategoryBadge(category: category, isSelected: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct CategoryFilterRow: View {
    @Binding var selectedCategories: Set<EventCategory>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(EventCategory.allCases) { category in
                    CategoryFilterChip(
                        category: category,
                        isSelected: selectedCategories.contains(category)
                    ) {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    }
                }
            }
            .padding(.horizontal)
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

        CategoryFilterRow(selectedCategories: .constant([.party, .concert]))
    }
    .padding()
}
