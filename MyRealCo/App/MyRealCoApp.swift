import SwiftUI

@main
struct MyRealCoApp: App {
    @StateObject private var auth = AuthService.shared
    @StateObject private var data = DataService.shared
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
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
}
