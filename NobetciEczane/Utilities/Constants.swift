import Foundation

struct Constants {
    static var nosyAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["NosyAPIKey"] as? String else {
            return ""
        }
        return key
    }
    static let nosyCitiesURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/cities"
    static let nosyAPIURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty"
}
