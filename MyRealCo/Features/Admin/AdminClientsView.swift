import SwiftUI

struct AdminClientsView: View {
    @EnvironmentObject var data: DataService
    @State private var showSendDoc = false
    @State private var showSendMsg = false
    @State private var selectedClientId = ""
    @State private var selectedClientName = ""

    // Derive unique clients from appointments
    var clients: [(id: String, name: String, email: String)] {
        var seen = Set<String>()
        return data.appointments.compactMap { appt -> (String, String, String)? in
            guard !seen.contains(appt.clientId) else { return nil }
            seen.insert(appt.clientId)
            return (appt.clientId, appt.clientName, appt.clientEmail)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if clients.isEmpty {
                    ContentUnavailableView("No Clients", systemImage: "person.badge.plus", description: Text("Clients with appointments will appear here."))
                } else {
                    List(clients, id: \.id) { client in
                        ClientLeadRow(
                            name: client.name,
                            email: client.email,
                            appointmentCount: data.appointments.filter { $0.clientId == client.id }.count,
                            documentCount: data.documents.filter { $0.clientId == client.id }.count,
                            onSendDocument: {
                                selectedClientId = client.id
                                selectedClientName = client.name
                                showSendDoc = true
                            },
                            onSendMessage: {
                                selectedClientId = client.id
                                selectedClientName = client.name
                                showSendMsg = true
                            }
                        )
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Clients")
            .sheet(isPresented: $showSendDoc) {
                SendDocumentView(clientId: selectedClientId, clientName: selectedClientName)
            }
            .sheet(isPresented: $showSendMsg) {
                SendMessageView(recipientId: selectedClientId, recipientName: selectedClientName)
            }
        }
    }
}

struct ClientLeadRow: View {
    let name: String
    let email: String
    let appointmentCount: Int
    let documentCount: Int
    let onSendDocument: () -> Void
    let onSendMessage: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.accentColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(name).font(.headline)
                    Text(email).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 16) {
                Label("\(appointmentCount) appt.", systemImage: "calendar")
                Label("\(documentCount) docs", systemImage: "doc")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Button {
                    onSendDocument()
                } label: {
                    Label("Send Doc", systemImage: "doc.badge.plus")
                        .font(.caption.bold())
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)

                Button {
                    onSendMessage()
                } label: {
                    Label("Message", systemImage: "message")
                        .font(.caption.bold())
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
            }
        }
        .padding(.vertical, 4)
    }
}
