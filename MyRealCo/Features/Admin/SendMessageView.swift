import SwiftUI

struct SendMessageView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var data: DataService
    @Environment(\.dismiss) var dismiss

    let recipientId: String
    let recipientName: String

    @State private var messageText = ""

    var thread: [Message] {
        guard let adminId = auth.currentUser?.id else { return [] }
        return data.messages.filter {
            ($0.senderId == adminId && $0.recipientId == recipientId) ||
            ($0.senderId == recipientId && $0.recipientId == adminId)
        }.sorted { $0.sentAt < $1.sentAt }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            ForEach(thread) { message in
                                MessageBubbleRow(message: message, currentUserId: auth.currentUser?.id ?? "")
                                    .padding(.horizontal)
                                    .id(message.id)
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: thread.count) { _, _ in
                        if let last = thread.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }

                Divider()
                HStack(spacing: 12) {
                    TextField("Message…", text: $messageText, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(messageText.isEmpty ? Color.secondary : Color.accentColor)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
            }
            .navigationTitle(recipientName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func send() {
        guard let admin = auth.currentUser, !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let message = Message(
            id: UUID().uuidString,
            senderId: admin.id,
            senderName: admin.name,
            recipientId: recipientId,
            body: messageText.trimmingCharacters(in: .whitespaces),
            sentAt: Date(),
            isRead: false
        )
        data.sendMessage(message)
        messageText = ""
    }
}
