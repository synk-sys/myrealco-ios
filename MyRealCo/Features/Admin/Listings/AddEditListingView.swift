import SwiftUI

struct AddEditListingView: View {
    @EnvironmentObject var data: DataService
    @Environment(\.dismiss) var dismiss

    let listing: Listing?

    @State private var title = ""
    @State private var address = ""
    @State private var price = ""
    @State private var bedrooms = "3"
    @State private var bathrooms = "2"
    @State private var squareFeet = ""
    @State private var description = ""
    @State private var status: Listing.ListingStatus = .available

    var isEditing: Bool { listing != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Property Details") {
                    TextField("Title", text: $title)
                    TextField("Address", text: $address)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Pricing (CAD)") {
                    HStack {
                        Text("CA$")
                            .foregroundStyle(.secondary)
                        TextField("Price", text: $price)
                            .keyboardType(.numberPad)
                    }
                }

                Section("Specs") {
                    HStack {
                        Text("Bedrooms")
                        Spacer()
                        TextField("3", text: $bedrooms)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                    HStack {
                        Text("Bathrooms")
                        Spacer()
                        TextField("2", text: $bathrooms)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                    HStack {
                        Text("Square Feet")
                        Spacer()
                        TextField("1200", text: $squareFeet)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                Section("Status") {
                    Picker("Status", selection: $status) {
                        ForEach(Listing.ListingStatus.allCases, id: \.self) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(isEditing ? "Edit Listing" : "New Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.isEmpty || address.isEmpty || price.isEmpty)
                }
            }
            .onAppear { prefill() }
        }
    }

    private func prefill() {
        guard let l = listing else { return }
        title = l.title
        address = l.address
        price = String(Int(l.price))
        bedrooms = String(l.bedrooms)
        bathrooms = String(l.bathrooms)
        squareFeet = String(l.squareFeet)
        description = l.description
        status = l.status
    }

    private func save() {
        let newListing = Listing(
            id: listing?.id ?? UUID().uuidString,
            title: title,
            address: address,
            price: Double(price) ?? 0,
            bedrooms: Int(bedrooms) ?? 0,
            bathrooms: Int(bathrooms) ?? 0,
            squareFeet: Int(squareFeet) ?? 0,
            description: description,
            imageURLs: listing?.imageURLs ?? [],
            status: status,
            createdAt: listing?.createdAt ?? Date()
        )
        if isEditing {
            data.updateListing(newListing)
        } else {
            data.addListing(newListing)
        }
        dismiss()
    }
}
