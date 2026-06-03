import Foundation

struct Constants {
    static let nosyAPIKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["NOSY_API_KEY"] as? String else {
            // During development, if Secrets.plist is missing, you can provide a fallback or crash.
            // Crashing helps identify missing configuration early.
            fatalError("Secrets.plist not found or NOSY_API_KEY is missing. Please check Secrets.plist.example")
        }
        return key
    }()

    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
