import Foundation

struct Constants {
    /// Loads the API key from Secrets.plist.
    /// This ensures that the sensitive API key is not hardcoded in the source code.
    static var nosyAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["NosyAPIKey"] as? String else {
            // Returns a placeholder if Secrets.plist is missing or key is not found.
            // In production, this should be handled more gracefully or during CI/CD.
            return "MISSING_API_KEY"
        }
        return key
    }

    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
