import Foundation

struct Document: Identifiable, Codable {
    let id: String
    var title: String
    var fileURL: String
    var fileType: String
    var sentAt: Date
    var clientId: String
    var description: String
}
