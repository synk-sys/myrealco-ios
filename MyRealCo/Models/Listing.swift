import Foundation

struct Listing: Identifiable, Codable {
    let id: String
    var title: String
    var address: String
    var price: Double
    var bedrooms: Int
    var bathrooms: Int
    var squareFeet: Int
    var description: String
    var imageURLs: [String]
    var status: ListingStatus
    var createdAt: Date

    enum ListingStatus: String, Codable, CaseIterable {
        case available = "Available"
        case underContract = "Under Contract"
        case sold = "Sold"
    }
}
