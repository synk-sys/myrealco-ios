import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    var clientId: String
    var clientName: String
    var clientEmail: String
    var listingId: String?
    var listingAddress: String
    var date: Date
    var notes: String
    var status: AppointmentStatus

    enum AppointmentStatus: String, Codable, CaseIterable {
        case pending = "Pending"
        case confirmed = "Confirmed"
        case cancelled = "Cancelled"
        case completed = "Completed"
    }
}
