import SwiftUI

struct AdminProfileView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 72))
                            .foregroundStyle(Color.brandTeal)
                        Text(auth.currentUser?.name ?? "")
                            .font(.title2.bold())
                        Text("Realtor · Admin")
                            .font(.subheadline)
                            .foregroundStyle(Color.brandGold)
                        Text(auth.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                if let phone = auth.currentUser?.phone {
                    Section("Contact") {
                        Label(phone, systemImage: "phone")
                            .foregroundStyle(Color.brandTeal)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        auth.logout()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
