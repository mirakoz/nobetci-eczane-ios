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

    /// Centralized and pre-sorted list of cities to improve performance by avoiding
    /// redundant allocations and sorting operations during UI re-renders.
    /// Expected impact: O(1) access instead of O(N log N) sorting on every view initialization.
    static let allCities: [String] = {
        let topCities = ["İstanbul", "Ankara", "İzmir"]
        let others = [
            "Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Aksaray", "Amasya", "Antalya",
            "Ardahan", "Artvin", "Aydın", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik",
            "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum",
            "Denizli", "Diyarbakır", "Düzce", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir",
            "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Iğdır", "Isparta",
            "Kahramanmaraş", "Karabük", "Karaman", "Kars", "Kastamonu", "Kayseri",
            "Kırıkkale", "Kırklareli", "Kırşehir", "Kilis", "Kocaeli", "Konya", "Kütahya", "Malatya",
            "Manisa", "Mardin", "Mersin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Osmaniye",
            "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Şanlıurfa", "Şırnak",
            "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Uşak", "Van", "Yalova", "Yozgat", "Zonguldak",
            "Kıbrıs KKTC"
        ].sorted()
        return topCities + others
    }()
}
