import Foundation

struct Constants {
    static let nosyAPIKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let secrets = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any] else {
            print("⚠️ Warning: Secrets.plist not found or invalid. API requests will fail.")
            return ""
        }

        guard let apiKey = secrets["NOSY_API_KEY"] as? String else {
            print("⚠️ Warning: NOSY_API_KEY not found in Secrets.plist.")
            return ""
        }

        return apiKey
    }()

    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
