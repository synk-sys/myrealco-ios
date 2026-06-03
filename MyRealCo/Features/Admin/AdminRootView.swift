import SwiftUI

struct AdminRootView: View {
    var body: some View {
        TabView {
            AdminListingsView()
                .tabItem { Label("Listings", systemImage: "house.fill") }

            AdminAppointmentsView()
                .tabItem { Label("Appointments", systemImage: "calendar") }

            AdminClientsView()
                .tabItem { Label("Clients", systemImage: "person.2.fill") }

            AdminProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
    }
}
