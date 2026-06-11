import Foundation
import UIKit

struct PhoneService {
    static func call(phoneNumber: String) -> Bool {
        // Use a whitelist filter (allowing only digits and '+') for phone number sanitization
        // to prevent malicious or malformed input from being passed to the 'tel:' URL scheme.
        let cleaned = phoneNumber.filter { $0.isNumber || $0 == "+" }
        guard let url = URL(string: "tel:\(cleaned)"),
              UIApplication.shared.canOpenURL(url) else {
            return false
        }
        UIApplication.shared.open(url)
        return true
    }

    static func openDirections(latitude: Double, longitude: Double, name: String) {
        if let url = URL(string: "maps://?daddr=\(latitude),\(longitude)&dirflg=d") {
            UIApplication.shared.open(url)
        }
    }
}