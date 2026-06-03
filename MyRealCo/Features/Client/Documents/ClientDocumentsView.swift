import SwiftUI

struct ClientDocumentsView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var data: DataService

    var myDocuments: [Document] {
        guard let uid = auth.currentUser?.id else { return [] }
        return data.documents(for: uid).sorted { $0.sentAt > $1.sentAt }
    }

    var body: some View {
        NavigationStack {
            Group {
                if myDocuments.isEmpty {
                    ContentUnavailableView("No Documents", systemImage: "doc.badge.plus", description: Text("Your realtor will send you documents here."))
                } else {
                    List(myDocuments) { document in
                        DocumentRow(document: document)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Documents")
        }
    }
}

struct DocumentRow: View {
    let document: Document

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "doc.fill")
                    .foregroundStyle(Color.brandTeal)
                Text(document.title)
                    .font(.headline)
            }
            Text(document.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack {
                Text(document.fileType)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.brandGold.opacity(0.15))
                    .foregroundStyle(Color.brandGold)
                    .clipShape(Capsule())
                Spacer()
                Text("Sent \(document.sentAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
