import SwiftUI

struct SendDocumentView: View {
    @EnvironmentObject var data: DataService
    @Environment(\.dismiss) var dismiss

    let clientId: String
    let clientName: String

    @State private var title = ""
    @State private var description = ""
    @State private var fileURL = ""
    @State private var fileType = "PDF"

    var body: some View {
        NavigationStack {
            Form {
                Section("Recipient") {
                    Label(clientName, systemImage: "person")
                }

                Section("Document") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("File URL (optional)", text: $fileURL)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    Picker("Type", selection: $fileType) {
                        Text("PDF").tag("PDF")
                        Text("Word").tag("DOCX")
                        Text("Image").tag("JPG")
                    }
                }
            }
            .navigationTitle("Send Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") { send() }
                        .disabled(title.isEmpty)
                }
            }
        }
    }

    private func send() {
        let doc = Document(
            id: UUID().uuidString,
            title: title,
            fileURL: fileURL,
            fileType: fileType,
            sentAt: Date(),
            clientId: clientId,
            description: description
        )
        data.sendDocument(doc)
        dismiss()
    }
}
