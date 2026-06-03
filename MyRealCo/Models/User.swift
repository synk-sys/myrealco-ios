import Foundation

enum UserRole: String, Codable {
    case client
    case admin
}

struct AppUser: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var role: UserRole
    var phone: String?
}
