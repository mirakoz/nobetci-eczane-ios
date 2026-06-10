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

    /// Pre-sorted list of cities to avoid redundant sorting on every view initialization.
    /// Major cities are listed first for convenience.
    static let allCities: [String] = [
        "İstanbul", "Ankara", "İzmir",
        "Adana", "Adıyaman", "Afyonkarahisar", "Aksaray", "Amasya", "Antalya", "Ardahan",
        "Artvin", "Aydın", "Ağrı", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik",
        "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Denizli", "Diyarbakır", "Düzce",
        "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun",
        "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Iğdır", "Kahramanmaraş", "Karabük",
        "Karaman", "Kars", "Kastamonu", "Kayseri", "Kilis", "Kocaeli", "Konya", "Kütahya",
        "Kıbrıs KKTC", "Kırklareli", "Kırıkkale", "Kırşehir", "Malatya", "Manisa", "Mardin",
        "Mersin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Osmaniye", "Rize",
        "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon",
        "Tunceli", "Uşak", "Van", "Yalova", "Yozgat", "Zonguldak", "Çanakkale", "Çankırı",
        "Çorum", "Şanlıurfa", "Şırnak"
    ]
}
