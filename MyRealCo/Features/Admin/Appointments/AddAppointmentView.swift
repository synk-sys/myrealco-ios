import SwiftUI

struct AddAppointmentView: View {
    @EnvironmentObject var data: DataService
    @Environment(\.dismiss) var dismiss

    @State private var clientName = ""
    @State private var clientEmail = ""
    @State private var listingAddress = ""
    @State private var date = Date()
    @State private var notes = ""
    @State private var status: Appointment.AppointmentStatus = .pending
    @State private var useExistingListing = false
    @State private var selectedListingIndex = 0

    var isFormValid: Bool {
        !clientName.isEmpty && !clientEmail.isEmpty && !listingAddress.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Client") {
                    TextField("Full Name", text: $clientName)
                        .textContentType(.name)
                    TextField("Email", text: $clientEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section("Property") {
                    Toggle("Select from Listings", isOn: $useExistingListing)
                        .tint(Color.brandTeal)

                    if useExistingListing && !data.listings.isEmpty {
                        Picker("Listing", selection: $selectedListingIndex) {
                            ForEach(data.listings.indices, id: \.self) { i in
                                Text(data.listings[i].address).tag(i)
                            }
                        }
                        .onChange(of: selectedListingIndex) { _, i in
                            listingAddress = data.listings[i].address
                        }
                        .onAppear {
                            listingAddress = data.listings[0].address
                        }
                    } else {
                        TextField("Property Address", text: $listingAddress)
                    }
                }

                Section("Date & Time") {
                    DatePicker("Appointment", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .tint(Color.brandTeal)
                }

                Section("Details") {
                    Picker("Status", selection: $status) {
                        ForEach(Appointment.AppointmentStatus.allCases, id: \.self) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("New Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!isFormValid)
                        .tint(Color.brandTeal)
                }
            }
        }
    }

    private func save() {
        let pickedListing = useExistingListing && !data.listings.isEmpty ? data.listings[selectedListingIndex] : nil
        let appointment = Appointment(
            id: UUID().uuidString,
            clientId: UUID().uuidString,
            clientName: clientName,
            clientEmail: clientEmail,
            listingId: pickedListing?.id,
            listingAddress: listingAddress,
            date: date,
            notes: notes,
            status: status
        )
        data.appointments.append(appointment)
        dismiss()
    }
}
