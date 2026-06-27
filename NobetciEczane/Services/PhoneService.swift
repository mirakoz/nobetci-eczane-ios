import Foundation
import UIKit

struct PhoneService {
    static func call(phoneNumber: String) -> Bool {
        // Use an allow-list (digits and '+') to sanitize the phone number for the tel: URL scheme.
        let cleaned = phoneNumber.filter { $0.isNumber || $0 == "+" }
        guard let url = URL(string: "tel:\(cleaned)"),
              UIApplication.shared.canOpenURL(url) else {
            return false
        }
        UIApplication.shared.open(url)
        return true
    }

    static func openDirections(latitude: Double, longitude: Double, name: String) {
        var components = URLComponents()
        components.scheme = "maps"
        components.queryItems = [
            URLQueryItem(name: "daddr", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "dirflg", value: "d")
        ]

        if let url = components.url {
            UIApplication.shared.open(url)
        }
    }
}