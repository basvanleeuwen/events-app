import SwiftUI

struct InterestButton: View {
    let event: Event
    @EnvironmentObject var userService: UserService

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
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    userService.toggleInterested(eventId: event.id)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isInterested ? "star.fill" : "star")
                        .font(.body)
                    Text("Interessant")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isInterested ? Color.yellow.opacity(0.2) : Color(.systemGray6))
                .foregroundStyle(isInterested ? .orange : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isInterested ? Color.orange.opacity(0.5) : Color.clear, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            // Going button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    userService.toggleGoing(eventId: event.id)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isGoing ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.body)
                    Text("Ik ga")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isGoing ? Color.green.opacity(0.2) : Color(.systemGray6))
                .foregroundStyle(isGoing ? .green : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isGoing ? Color.green.opacity(0.5) : Color.clear, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

struct CompactInterestButton: View {
    let event: Event
    @EnvironmentObject var userService: UserService

    var isInterested: Bool {
        userService.isInterested(in: event.id)
    }

    var isGoing: Bool {
        userService.isGoing(to: event.id)
    }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if isGoing {
                    userService.toggleGoing(eventId: event.id)
                } else if isInterested {
                    userService.toggleGoing(eventId: event.id)
                } else {
                    userService.toggleInterested(eventId: event.id)
                }
            }
        } label: {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray6))
                .clipShape(Circle())
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
}

#Preview {
    VStack(spacing: 20) {
        InterestButton(event: .preview)
        CompactInterestButton(event: .preview)
    }
    .padding()
    .environmentObject(UserService.shared)
}
