import SwiftUI

@main
struct MyRealCoApp: App {
    @StateObject private var auth = AuthService.shared
    @StateObject private var data = DataService.shared

    var body: some Scene {
        WindowGroup {
            if auth.isLoggedIn, let user = auth.currentUser {
                switch user.role {
                case .admin:
                    AdminRootView()
                        .environmentObject(auth)
                        .environmentObject(data)
                case .client:
                    ClientRootView()
                        .environmentObject(auth)
                        .environmentObject(data)
                }
            } else {
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}
