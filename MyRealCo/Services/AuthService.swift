import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var currentUser: AppUser?
    @Published var isLoggedIn: Bool = false

    private let userKey = "myrealco_current_user"

    init() {
        loadSavedSession()
    }

    func login(email: String, password: String) throws -> AppUser {
        // Mock credentials — replace with real backend auth
        let mockUsers: [(email: String, password: String, user: AppUser)] = [
            ("smanocha@myrealco.com", "admin123", AppUser(id: "admin-1", name: "Sanjeev Manocha", email: "smanocha@myrealco.com", role: .admin, phone: "555-0100")),
            ("client@myrealco.com", "client123", AppUser(id: "client-1", name: "Alex Martinez", email: "client@myrealco.com", role: .client, phone: "555-0200")),
            ("client2@myrealco.com", "client123", AppUser(id: "client-2", name: "Jamie Lee", email: "client2@myrealco.com", role: .client, phone: "555-0300")),
        ]

        guard let match = mockUsers.first(where: { $0.email == email && $0.password == password }) else {
            throw AuthError.invalidCredentials
        }

        let user = match.user
        saveSession(user)
        return user
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    private func saveSession(_ user: AppUser) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
        currentUser = user
        isLoggedIn = true
    }

    private func loadSavedSession() {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(AppUser.self, from: data) else { return }
        currentUser = user
        isLoggedIn = true
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid email or password."
        }
    }
}
