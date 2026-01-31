import SwiftUI

struct EventCardView: View {
    let event: Event
    @EnvironmentObject var userService: UserService
    @State private var isPressed = false

    var isInterested: Bool {
        userService.isInterested(in: event.id)
    }

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero image area with category-specific illustration
            ZStack(alignment: .bottom) {
                // Background gradient
                Rectangle()
                    .fill(categoryGradient)
                    .frame(height: 160)
                    .overlay(
                        // Category-specific illustration
                        CategoryIllustration(category: event.category)
                    )
                    .clipped()

                // Bottom gradient overlay for text readability
                LinearGradient(
                    colors: [.clear, .black.opacity(0.5)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: 80)

                // Overlay content
                HStack(alignment: .bottom) {
                    // Date badge
                    VStack(spacing: 2) {
                        Text(dayOfMonth)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text(monthAbbrev)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .textCase(.uppercase)
                    }
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial)
                    .background(Color.white.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                    Spacer()

                    // Status indicator
                    if isGoing || isInterested {
                        statusIndicator
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(14)
            }

            // Content area
            VStack(alignment: .leading, spacing: 12) {
                // Category pill
                HStack(spacing: 6) {
                    Image(systemName: event.category.icon)
                        .font(.system(size: 11, weight: .semibold))
                    Text(event.category.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(categoryColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(categoryColor.opacity(0.12))
                .clipShape(Capsule())

                // Title
                Text(event.title)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Info row
                HStack(spacing: 16) {
                    // Time
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(categoryColor)
                        Text(event.formattedTime)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(.secondary)

                    // Location
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(categoryColor)
                        Text(event.location.name)
                            .font(.system(size: 13, weight: .medium))
                            .lineLimit(1)
                    }
                    .foregroundStyle(.secondary)
                }

                // Divider
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 1)

                // Bottom row: Price & Social proof
                HStack {
                    // Price tag
                    HStack(spacing: 5) {
                        if event.price.isFree {
                            Image(systemName: "gift.fill")
                                .font(.system(size: 13))
                        }
                        Text(event.price.displayText)
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundStyle(event.price.isFree ? .green : .primary)

                    Spacer()

                    // Social proof
                    if event.goingCount > 0 || event.interestedCount > 0 {
                        HStack(spacing: 14) {
                            if event.goingCount > 0 {
                                HStack(spacing: 5) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.green)
                                    Text("\(event.goingCount)")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                            }
                            if event.interestedCount > 0 {
                                HStack(spacing: 5) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.orange)
                                    Text("\(event.interestedCount)")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: categoryColor.opacity(0.2), radius: 16, x: 0, y: 8)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }

    private var categoryGradient: LinearGradient {
        LinearGradient(
            colors: [categoryColor, categoryColorSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var categoryColor: Color {
        switch event.category {
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
        switch event.category {
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

    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.date)
    }

    private var monthAbbrev: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.date)
    }

    @ViewBuilder
    private var statusIndicator: some View {
        if isGoing {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("Ik ga")
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.green)
            .clipShape(Capsule())
            .shadow(color: .green.opacity(0.4), radius: 8, x: 0, y: 4)
        } else if isInterested {
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(10)
            .background(.orange)
            .clipShape(Circle())
            .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Category Illustrations

struct CategoryIllustration: View {
    let category: EventCategory

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Base decorative elements
                ForEach(0..<decorativeElements.count, id: \.self) { index in
                    let element = decorativeElements[index]
                    element.shape
                        .fill(Color.white.opacity(element.opacity))
                        .frame(width: element.size, height: element.size)
                        .offset(
                            x: element.xOffset * geo.size.width,
                            y: element.yOffset * geo.size.height
                        )
                        .rotationEffect(.degrees(element.rotation))
                }

                // Main icon
                Image(systemName: category.icon)
                    .font(.system(size: 70, weight: .thin))
                    .foregroundStyle(.white.opacity(0.15))
                    .offset(x: geo.size.width * 0.25, y: -10)

                // Category-specific decorations
                categorySpecificDecoration(in: geo)
            }
        }
    }

    private var decorativeElements: [DecorativeElement] {
        switch category {
        case .party, .nightlife:
            return [
                DecorativeElement(shape: AnyShape(Circle()), size: 120, opacity: 0.12, xOffset: 0.6, yOffset: -0.2, rotation: 0),
                DecorativeElement(shape: AnyShape(Circle()), size: 80, opacity: 0.08, xOffset: -0.3, yOffset: 0.3, rotation: 0),
                DecorativeElement(shape: AnyShape(Circle()), size: 40, opacity: 0.15, xOffset: 0.1, yOffset: -0.3, rotation: 0),
                DecorativeElement(shape: AnyShape(Star(corners: 4, smoothness: 0.5)), size: 30, opacity: 0.2, xOffset: 0.7, yOffset: 0.2, rotation: 15),
                DecorativeElement(shape: AnyShape(Star(corners: 4, smoothness: 0.5)), size: 20, opacity: 0.15, xOffset: -0.2, yOffset: -0.2, rotation: 30)
            ]
        case .concert:
            return [
                DecorativeElement(shape: AnyShape(Circle()), size: 150, opacity: 0.1, xOffset: 0.5, yOffset: 0, rotation: 0),
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 4)), size: 60, opacity: 0.12, xOffset: -0.3, yOffset: 0.2, rotation: 20),
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 4)), size: 40, opacity: 0.08, xOffset: -0.25, yOffset: 0.25, rotation: 20),
                DecorativeElement(shape: AnyShape(Circle()), size: 25, opacity: 0.15, xOffset: 0.15, yOffset: -0.3, rotation: 0)
            ]
        case .culture:
            return [
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 8)), size: 100, opacity: 0.1, xOffset: 0.55, yOffset: 0.1, rotation: 15),
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 8)), size: 70, opacity: 0.08, xOffset: 0.45, yOffset: 0.15, rotation: 25),
                DecorativeElement(shape: AnyShape(Circle()), size: 50, opacity: 0.12, xOffset: -0.25, yOffset: -0.2, rotation: 0)
            ]
        case .sport, .outdoor:
            return [
                DecorativeElement(shape: AnyShape(Circle()), size: 100, opacity: 0.12, xOffset: 0.6, yOffset: 0.1, rotation: 0),
                DecorativeElement(shape: AnyShape(Capsule()), size: 80, opacity: 0.08, xOffset: -0.2, yOffset: 0.2, rotation: 45),
                DecorativeElement(shape: AnyShape(Circle()), size: 30, opacity: 0.15, xOffset: 0.2, yOffset: -0.25, rotation: 0)
            ]
        case .food:
            return [
                DecorativeElement(shape: AnyShape(Circle()), size: 120, opacity: 0.12, xOffset: 0.55, yOffset: 0.05, rotation: 0),
                DecorativeElement(shape: AnyShape(Circle()), size: 60, opacity: 0.1, xOffset: -0.3, yOffset: 0.15, rotation: 0),
                DecorativeElement(shape: AnyShape(Circle()), size: 35, opacity: 0.15, xOffset: 0.1, yOffset: -0.25, rotation: 0)
            ]
        case .market:
            return [
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 6)), size: 90, opacity: 0.1, xOffset: 0.5, yOffset: 0.1, rotation: 10),
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 6)), size: 60, opacity: 0.08, xOffset: -0.25, yOffset: 0.2, rotation: -10),
                DecorativeElement(shape: AnyShape(Circle()), size: 40, opacity: 0.12, xOffset: 0.15, yOffset: -0.2, rotation: 0)
            ]
        case .workshop:
            return [
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 10)), size: 100, opacity: 0.1, xOffset: 0.55, yOffset: 0, rotation: 5),
                DecorativeElement(shape: AnyShape(Circle()), size: 50, opacity: 0.12, xOffset: -0.3, yOffset: 0.2, rotation: 0),
                DecorativeElement(shape: AnyShape(RoundedRectangle(cornerRadius: 4)), size: 30, opacity: 0.15, xOffset: 0.1, yOffset: 0.25, rotation: -15)
            ]
        case .community:
            return [
                DecorativeElement(shape: AnyShape(Circle()), size: 100, opacity: 0.12, xOffset: 0.5, yOffset: 0, rotation: 0),
                DecorativeElement(shape: AnyShape(Circle()), size: 70, opacity: 0.1, xOffset: 0.35, yOffset: 0.15, rotation: 0),
                DecorativeElement(shape: AnyShape(Circle()), size: 50, opacity: 0.08, xOffset: -0.25, yOffset: 0.1, rotation: 0)
            ]
        }
    }

    @ViewBuilder
    private func categorySpecificDecoration(in geo: GeometryProxy) -> some View {
        switch category {
        case .party, .nightlife:
            // Disco ball effect
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: cos(Double(i) * .pi / 4) * 50 + geo.size.width * 0.15,
                        y: sin(Double(i) * .pi / 4) * 50 - 20
                    )
            }
        case .concert:
            // Sound wave lines
            ForEach(0..<4, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 4, height: CGFloat(20 + i * 15))
                    .offset(x: CGFloat(-40 + i * 15), y: 20)
            }
        case .outdoor:
            // Mountain peaks
            Triangle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 80, height: 50)
                .offset(x: -geo.size.width * 0.3, y: 30)
            Triangle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 60, height: 40)
                .offset(x: -geo.size.width * 0.15, y: 35)
        default:
            EmptyView()
        }
    }
}

struct DecorativeElement {
    let shape: AnyShape
    let size: CGFloat
    let opacity: Double
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotation: Double
}

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

struct Star: Shape {
    let corners: Int
    let smoothness: CGFloat

    func path(in rect: CGRect) -> Path {
        guard corners >= 2 else { return Path() }

        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * smoothness

        var path = Path()
        let adjustment = -CGFloat.pi / 2

        for i in 0..<corners * 2 {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = CGFloat(i) * .pi / CGFloat(corners) + adjustment

            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Event Row View

struct EventRowView: View {
    let event: Event
    @EnvironmentObject var userService: UserService

    var body: some View {
        HStack(spacing: 14) {
            // Mini illustration
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColorSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                VStack(spacing: 2) {
                    Text(dayOfMonth)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text(monthAbbrev)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .textCase(.uppercase)
                }
                .foregroundStyle(.white)
            }
            .shadow(color: categoryColor.opacity(0.3), radius: 6, x: 0, y: 3)

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(event.formattedTime)
                    }

                    Text("•")

                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 10))
                        Text(event.location.name)
                            .lineLimit(1)
                    }
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }

            Spacer()

            // Price badge
            Text(event.price.displayText)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(event.price.isFree ? .green : .secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(event.price.isFree ? Color.green.opacity(0.12) : Color(.systemGray6))
                .clipShape(Capsule())

            // Quick action
            CompactInterestButton(event: event)
        }
        .padding(.vertical, 10)
    }

    private var categoryColor: Color {
        switch event.category {
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
        switch event.category {
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

    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.date)
    }

    private var monthAbbrev: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.date)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            EventCardView(event: .preview)
                .padding(.horizontal)

            Divider()

            EventRowView(event: .preview)
                .padding(.horizontal)
        }
    }
    .environmentObject(UserService.shared)
}
