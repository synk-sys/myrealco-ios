import Foundation

struct Message: Identifiable, Codable {
    let id: String
    var senderId: String
    var senderName: String
    var recipientId: String
    var body: String
    var sentAt: Date
    var isRead: Bool
}
