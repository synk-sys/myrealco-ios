import SwiftUI

struct AdminListingsView: View {
    @EnvironmentObject var data: DataService
    @State private var showAddListing = false
    @State private var listingToEdit: Listing?
    @State private var listingToDelete: Listing?
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            Group {
                if data.listings.isEmpty {
                    ContentUnavailableView("No Listings", systemImage: "house.badge.plus", description: Text("Tap + to add your first listing."))
                } else {
                    List {
                        ForEach(data.listings) { listing in
                            AdminListingRow(listing: listing)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        listingToDelete = listing
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    Button {
                                        listingToEdit = listing
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(Color.brandGold)
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Listings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddListing = true } label: {
                        Image(systemName: "plus")
                    }
                    .tint(Color.brandTeal)
                }
            }
            .sheet(isPresented: $showAddListing) {
                AddEditListingView(listing: nil)
            }
            .sheet(item: $listingToEdit) { listing in
                AddEditListingView(listing: listing)
            }
            .alert("Delete Listing?", isPresented: $showDeleteAlert, presenting: listingToDelete) { listing in
                Button("Delete", role: .destructive) {
                    data.deleteListing(id: listing.id)
                }
                Button("Cancel", role: .cancel) {}
            } message: { listing in
                Text("\"\(listing.title)\" will be permanently removed.")
            }
        }
    }
}

struct AdminListingRow: View {
    let listing: Listing

    var statusColor: Color {
        switch listing.status {
        case .available:     return .brandTeal
        case .underContract: return .brandGold
        case .sold:          return .secondary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(listing.title).font(.headline)
                Spacer()
                Text(listing.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(statusColor.opacity(0.15))
                    .foregroundStyle(statusColor)
                    .clipShape(Capsule())
            }
            Text(listing.address).font(.subheadline).foregroundStyle(.secondary)
            HStack {
                Text(listing.price, format: .currency(code: "CAD").precision(.fractionLength(0)))
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.brandGold)
                Spacer()
                Text("\(listing.bedrooms)bd · \(listing.bathrooms)ba · \(listing.squareFeet) sqft")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
