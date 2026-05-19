import Foundation

struct Pharmacy: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let address: String
    let phone: String
    let phone2: String?
    let latitude: Double
    let longitude: Double
    var distance: Double?
    let city: String
    let district: String
    let town: String?
    let directions: String?
    let pharmacyDutyStart: String?
    let pharmacyDutyEnd: String?

    enum CodingKeys: String, CodingKey {
        case id = "pharmacyID"
        case name = "pharmacyName"
        case address, phone, phone2, latitude, longitude, city, district, town, directions
        case pharmacyDutyStart = "pharmacyDutyStart"
        case pharmacyDutyEnd = "pharmacyDutyEnd"
    }

    var isCallable: Bool {
        phone.contains("*") == false && phone.count >= 10
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