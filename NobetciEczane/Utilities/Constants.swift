import Foundation

struct Constants {
    /// The API key for NosyAPI, loaded from an ignored Secrets.plist to prevent credential leakage.
    static let nosyAPIKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = plist["NOSY_API_KEY"] as? String else {
            return ""
        }
        return key
    }()

    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
