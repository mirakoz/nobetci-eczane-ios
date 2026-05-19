import Foundation

struct Pharmacy: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let address: String
    let phone: String
    let latitude: Double
    let longitude: Double
    var distance: Double?
    var isOpen: Bool

    var distanceText: String {
        guard let d = distance else { return "" }
        return String(format: "%.1f km", d)
    }
}

struct PharmacyAPIResponse: Codable {
    let data: [Pharmacy]?
    let message: String?
    let status: String?
}