import SwiftUI

struct InterestButton: View {
    let event: Event
    @EnvironmentObject var userService: UserService
    @State private var starScale: CGFloat = 1
    @State private var checkScale: CGFloat = 1

    var isInterested: Bool {
        userService.isInterested(in: event.id)
    }

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Interested button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    userService.toggleInterested(eventId: event.id)
                }
                // Bounce animation
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    starScale = 1.3
                }
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5).delay(0.1)) {
                    starScale = 1
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isInterested ? "star.fill" : "star")
                        .font(.system(size: 16, weight: .semibold))
                        .scaleEffect(starScale)
                        .symbolEffect(.bounce, value: isInterested)
                    Text("Interessant")
                        .font(.system(size: 15, weight: .semibold))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    Group {
                        if isInterested {
                            LinearGradient(
                                colors: [Color.orange.opacity(0.15), Color.yellow.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color(.systemGray6)
                        }
                    }
                )
                .foregroundStyle(isInterested ? .orange : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isInterested
                                ? LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color.clear], startPoint: .leading, endPoint: .trailing),
                            lineWidth: 2
                        )
                )
                .shadow(color: isInterested ? .orange.opacity(0.2) : .clear, radius: 8, x: 0, y: 4)
            }
            .buttonStyle(ScaleButtonStyle())

            // Going button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    userService.toggleGoing(eventId: event.id)
                }
                // Bounce animation
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    checkScale = 1.3
                }
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5).delay(0.1)) {
                    checkScale = 1
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isGoing ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.system(size: 16, weight: .semibold))
                        .scaleEffect(checkScale)
                        .symbolEffect(.bounce, value: isGoing)
                    Text("Ik ga")
                        .font(.system(size: 15, weight: .semibold))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    Group {
                        if isGoing {
                            LinearGradient(
                                colors: [Color.green.opacity(0.15), Color.mint.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color(.systemGray6)
                        }
                    }
                )
                .foregroundStyle(isGoing ? .green : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isGoing
                                ? LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color.clear], startPoint: .leading, endPoint: .trailing),
                            lineWidth: 2
                        )
                )
                .shadow(color: isGoing ? .green.opacity(0.2) : .clear, radius: 8, x: 0, y: 4)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}

struct CompactInterestButton: View {
    let event: Event
    @EnvironmentObject var userService: UserService
    @State private var scale: CGFloat = 1

    var isInterested: Bool {
        userService.isInterested(in: event.id)
    }

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                if isGoing {
                    userService.toggleGoing(eventId: event.id)
                } else if isInterested {
                    userService.toggleGoing(eventId: event.id)
                } else {
                    userService.toggleInterested(eventId: event.id)
                }
            }
            // Bounce animation
            withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                scale = 1.2
            }
            withAnimation(.spring(response: 0.15, dampingFraction: 0.5).delay(0.1)) {
                scale = 1
            }
        } label: {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 40, height: 40)

                Circle()
                    .strokeBorder(borderColor, lineWidth: 2)
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconColor)
                    .scaleEffect(scale)
            }
            .shadow(color: shadowColor, radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var icon: String {
        if isGoing {
            return "checkmark.circle.fill"
        } else if isInterested {
            return "star.fill"
        }
        return "star"
    }

    private var iconColor: Color {
        if isGoing {
            return .green
        } else if isInterested {
            return .orange
        }
        return .secondary
    }

    private var backgroundColor: Color {
        if isGoing {
            return Color.green.opacity(0.1)
        } else if isInterested {
            return Color.orange.opacity(0.1)
        }
        return Color(.systemGray6)
    }

    private var borderColor: Color {
        if isGoing {
            return .green.opacity(0.3)
        } else if isInterested {
            return .orange.opacity(0.3)
        }
        return .clear
    }

    private var shadowColor: Color {
        if isGoing {
            return .green.opacity(0.15)
        } else if isInterested {
            return .orange.opacity(0.15)
        }
        return .clear
    }
}

#Preview {
    VStack(spacing: 20) {
        InterestButton(event: .preview)
        CompactInterestButton(event: .preview)
    }
    .padding()
    .environmentObject(UserService.shared)
}
