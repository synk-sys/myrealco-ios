import Foundation
import Combine

// Mock in-memory data service. Swap fetch methods with real API/Firebase calls.
class DataService: ObservableObject {
    static let shared = DataService()

    @Published var listings: [Listing] = []
    @Published var appointments: [Appointment] = []
    @Published var documents: [Document] = []
    @Published var messages: [Message] = []

    init() {
        seedData()
    }

    // MARK: - Listings

    func addListing(_ listing: Listing) {
        listings.append(listing)
    }

    func updateListing(_ listing: Listing) {
        if let index = listings.firstIndex(where: { $0.id == listing.id }) {
            listings[index] = listing
        }
    }

    func deleteListing(id: String) {
        listings.removeAll { $0.id == id }
    }

    // MARK: - Appointments

    func appointments(for clientId: String) -> [Appointment] {
        appointments.filter { $0.clientId == clientId }
    }

    func updateAppointmentStatus(id: String, status: Appointment.AppointmentStatus) {
        if let index = appointments.firstIndex(where: { $0.id == id }) {
            appointments[index].status = status
        }
    }

    func deleteAppointment(id: String) {
        appointments.removeAll { $0.id == id }
    }

    // MARK: - Documents

    func documents(for clientId: String) -> [Document] {
        documents.filter { $0.clientId == clientId }
    }

    func sendDocument(_ document: Document) {
        documents.append(document)
    }

    // MARK: - Messages

    func messages(for userId: String) -> [Message] {
        messages.filter { $0.recipientId == userId || $0.senderId == userId }
            .sorted { $0.sentAt < $1.sentAt }
    }

    func sendMessage(_ message: Message) {
        messages.append(message)
    }

    func markMessageRead(id: String) {
        if let index = messages.firstIndex(where: { $0.id == id }) {
            messages[index].isRead = true
        }
    }

    // MARK: - Seed

    private func seedData() {
        let now = Date()
        let calendar = Calendar.current

        listings = [
            Listing(id: "l1", title: "Modern Downtown Condo", address: "123 Main St, Unit 4B", price: 485000, bedrooms: 2, bathrooms: 2, squareFeet: 1100, description: "Stunning city views from this modern condo in the heart of downtown. Open floor plan with high-end finishes.", imageURLs: [], status: .available, createdAt: now),
            Listing(id: "l2", title: "Suburban Family Home", address: "456 Oak Drive", price: 620000, bedrooms: 4, bathrooms: 3, squareFeet: 2400, description: "Spacious family home in a quiet neighborhood with large backyard. Top-rated school district.", imageURLs: [], status: .available, createdAt: now),
            Listing(id: "l3", title: "Cozy Starter Home", address: "789 Elm St", price: 310000, bedrooms: 3, bathrooms: 1, squareFeet: 1300, description: "Perfect starter home with recent updates to kitchen and bathrooms. Large lot with mature trees.", imageURLs: [], status: .underContract, createdAt: now),
        ]

        appointments = [
            Appointment(id: "a1", clientId: "client-1", clientName: "Alex Martinez", clientEmail: "client@myrealco.com", listingId: "l1", listingAddress: "123 Main St, Unit 4B", date: calendar.date(byAdding: .day, value: 3, to: now)!, notes: "Interested in the view units", status: .confirmed),
            Appointment(id: "a2", clientId: "client-1", clientName: "Alex Martinez", clientEmail: "client@myrealco.com", listingId: "l2", listingAddress: "456 Oak Drive", date: calendar.date(byAdding: .day, value: 7, to: now)!, notes: "Bringing spouse along", status: .pending),
            Appointment(id: "a3", clientId: "client-2", clientName: "Jamie Lee", clientEmail: "client2@myrealco.com", listingId: "l3", listingAddress: "789 Elm St", date: calendar.date(byAdding: .day, value: -2, to: now)!, notes: "", status: .completed),
        ]

        documents = [
            Document(id: "d1", title: "Purchase Agreement - 123 Main St", fileURL: "https://example.com/docs/d1.pdf", fileType: "PDF", sentAt: calendar.date(byAdding: .day, value: -1, to: now)!, clientId: "client-1", description: "Please review and sign the purchase agreement for your offer on Unit 4B."),
            Document(id: "d2", title: "Home Inspection Report", fileURL: "https://example.com/docs/d2.pdf", fileType: "PDF", sentAt: calendar.date(byAdding: .day, value: -3, to: now)!, clientId: "client-1", description: "Full inspection report from the certified inspector. Minor repairs noted on page 4."),
        ]

        messages = [
            Message(id: "m1", senderId: "admin-1", senderName: "Sarah Johnson", recipientId: "client-1", body: "Hi Alex! I wanted to let you know your viewing for 123 Main St is confirmed for this Thursday at 2 PM. See you there!", sentAt: calendar.date(byAdding: .hour, value: -5, to: now)!, isRead: false),
            Message(id: "m2", senderId: "admin-1", senderName: "Sarah Johnson", recipientId: "client-1", body: "Great news — the seller has accepted your offer on 123 Main St! I've sent over the purchase agreement for your review.", sentAt: calendar.date(byAdding: .hour, value: -2, to: now)!, isRead: false),
        ]
    }
}
