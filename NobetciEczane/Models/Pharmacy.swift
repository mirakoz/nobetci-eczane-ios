import Foundation

struct Pharmacy: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let address: String
    let phone: String
    let latitude: Double
    let longitude: Double
    var distance: Double?
    let city: String
    let district: String

    enum CodingKeys: String, CodingKey {
        case id = "pharmacyID"
        case name = "pharmacyName"
        case address, phone, latitude, longitude, city, district
    }
}

struct PharmacyAPIResponse: Codable {
    let status: String
    let message: String?
    let messageTR: String?
    let systemTime: Int?
    let endpoint: String?
    let rowCount: Int?
    let creditUsed: Int?
    let data: [Pharmacy]?
}