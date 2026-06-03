import SwiftUI

struct ClientMessagesView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var data: DataService

    var myMessages: [Message] {
        guard let uid = auth.currentUser?.id else { return [] }
        return data.messages(for: uid)
    }

    var unreadCount: Int {
        guard let uid = auth.currentUser?.id else { return 0 }
        return myMessages.filter { $0.recipientId == uid && !$0.isRead }.count
    }

    var body: some View {
        NavigationStack {
            Group {
                if myMessages.isEmpty {
                    ContentUnavailableView("No Messages", systemImage: "message", description: Text("Messages from your realtor will appear here."))
                } else {
                    List(myMessages.reversed()) { message in
                        MessageBubbleRow(message: message, currentUserId: auth.currentUser?.id ?? "")
                            .onAppear {
                                if !message.isRead, message.recipientId == auth.currentUser?.id {
                                    data.markMessageRead(id: message.id)
                                }
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(unreadCount > 0 ? "Messages (\(unreadCount))" : "Messages")
        }
    }
}

struct MessageBubbleRow: View {
    let message: Message
    let currentUserId: String

    var isFromMe: Bool { message.senderId == currentUserId }

    var body: some View {
        VStack(alignment: isFromMe ? .trailing : .leading, spacing: 4) {
            if !isFromMe {
                Text(message.senderName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(message.body)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isFromMe ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(isFromMe ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: 280, alignment: isFromMe ? .trailing : .leading)
            Text(message.sentAt.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: isFromMe ? .trailing : .leading)
        .listRowSeparator(.hidden)
        .padding(.vertical, 4)
    }
}
