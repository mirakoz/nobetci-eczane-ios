import Foundation

struct Constants {
    static var nosyAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["NosyAPIKey"] as? String else {
            // In a real app, you might want to handle this more gracefully
            // but for now we'll return a placeholder or empty string
            // if the secret is missing to avoid a crash.
            return ""
        }
        return key
    }

    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
