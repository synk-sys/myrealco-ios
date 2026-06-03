import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 4) {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text("Your trusted real estate partner")
                            .font(.subheadline)
                            .foregroundStyle(Color.brandTeal)
                    }
                    .padding(.top, 32)

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email").font(.caption).foregroundStyle(.secondary)
                            TextField("you@example.com", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password").font(.caption).foregroundStyle(.secondary)
                            SecureField("••••••••", text: $password)
                                .textContentType(.password)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(Color.brandRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            login()
                        } label: {
                            Group {
                                if isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Sign In").fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandTeal)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 4) {
                        Text("Demo credentials").font(.caption).foregroundStyle(.secondary)
                        Text("Admin: smanocha@myrealco.com / admin123").font(.caption2).foregroundStyle(.secondary)
                        Text("Client: client@myrealco.com / client123").font(.caption2).foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
    }

    private func login() {
        errorMessage = ""
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            do {
                let user = try auth.login(email: email, password: password)
                auth.currentUser = user
                auth.isLoggedIn = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
