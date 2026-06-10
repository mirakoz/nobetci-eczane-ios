import Foundation
import UIKit

struct PhoneService {
    static func call(phoneNumber: String) -> Bool {
        // Whitelist: Allow only digits and '+' for tel: URL scheme
        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+"))
        let cleaned = phoneNumber.filter { char in
            guard let unicodeScalar = char.unicodeScalars.first else { return false }
            return allowed.contains(unicodeScalar)
        }

        guard !cleaned.isEmpty,
              let url = URL(string: "tel:\(cleaned)"),
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