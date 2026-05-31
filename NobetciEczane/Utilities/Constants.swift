import Foundation

struct Constants {
    static let nosyAPIKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let secrets = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: String],
              let key = secrets["NOSY_API_KEY"] else {
            // Fallback to empty string if not found, or handle as error in production
            return ""
        }
        return key
    }()

    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
