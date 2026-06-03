import SwiftUI

struct ClientRootView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        TabView {
            ClientAppointmentsView()
                .tabItem { Label("Appointments", systemImage: "calendar") }

            ClientDocumentsView()
                .tabItem { Label("Documents", systemImage: "doc.fill") }

            ClientMessagesView()
                .tabItem { Label("Messages", systemImage: "message.fill") }

            ClientProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
    }
}
