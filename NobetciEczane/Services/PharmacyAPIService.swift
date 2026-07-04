import Foundation

actor PharmacyAPIService {
    private let apiKey = Constants.nosyAPIKey
    private let baseURL = Constants.nosyAPIURL

    func fetchPharmacies(city: String, district: String? = nil) async throws -> [Pharmacy] {
        // Check cache first
        let (cached, isStale) = PharmacyCache.shared.cachedPharmacies(city: city, district: district)
        if !cached.isEmpty && !isStale {
            return cached
        }

        var urlString = "\(baseURL)?city=\(city.slugified())"
        if let district = district, !district.isEmpty {
            urlString += "&district=\(district.slugified())"
        }

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoded = try JSONDecoder().decode(PharmacyAPIResponse.self, from: data)

        guard decoded.status == "success", let pharmacies = decoded.data else {
            // Fall back to stale cache if available
            if !cached.isEmpty {
                return cached
            }
            throw APIError.decodingError(message: decoded.message ?? "Unknown error")
        }

        // Cache the fresh result
        PharmacyCache.shared.cachePharmacies(pharmacies, city: city, district: district)

        return pharmacies
    }

    func fetchDistricts(city: String) async throws -> [District] {
        let urlString = "\(Constants.nosyCitiesURL)?city=\(city.slugified())"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoded = try JSONDecoder().decode(DistrictsAPIResponse.self, from: data)
        return decoded.data ?? []
    }

    func fetchAllCities() async throws -> [City] {
        guard let url = URL(string: Constants.nosyCitiesURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoded = try JSONDecoder().decode(CitiesAPIResponse.self, from: data)
        return decoded.data ?? []
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Geçersiz URL"
        case .invalidResponse: return "Sunucudan geçersiz yanıt"
        case .httpError(let code): return "HTTP hatası: \(code)"
        case .decodingError(let msg): return "Veri hatası: \(msg)"
        }
    }
}

struct DistrictsAPIResponse: Codable {
    let status: String
    let message: String?
    let rowCount: Int?
    let creditUsed: Int?
    let data: [District]?
}

struct CityDistrict: Codable {
    let cities: String
    let slug: String
}

struct DistrictsAPIResponse2: Codable {
    let status: String
    let data: [CityDistrict]?
}

struct District: Identifiable, Codable, Hashable {
    var id: String { slug }
    let cities: String
    let slug: String

    var displayName: String { cities }

    init(cities: String, slug: String) {
        self.cities = cities
        self.slug = slug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cities = try container.decode(String.self, forKey: .cities)
        slug = try container.decode(String.self, forKey: .slug)
    }

    enum CodingKeys: String, CodingKey {
        case cities, slug
    }
}

struct CitiesAPIResponse: Codable {
    let status: String
    let rowCount: Int?
    let creditUsed: Int?
    let data: [City]?
}

struct City: Identifiable, Codable, Hashable {
    var id: String { slug }
    let cities: String
    let slug: String

    var displayName: String { cities }
}

extension String {
    private static let turkishMap: [Character: String] = [
        "İ": "i", "I": "i", "ı": "i",
        "Ş": "s", "ş": "s",
        "Ğ": "g", "ğ": "g",
        "Ü": "u", "ü": "u",
        "Ö": "o", "ö": "o",
        "Ç": "c", "ç": "c",
        " ": "-"
    ]

    func slugified() -> String {
        var result = ""
        result.reserveCapacity(self.count)

        for char in self {
            if let replacement = Self.turkishMap[char] {
                result.append(replacement)
            } else {
                let lowered = char.lowercased()
                if lowered.count == 1 {
                    let c = lowered.first!
                    if c.isLetter || c.isNumber || c == "-" {
                        result.append(c)
                    }
                }
            }
        }
        return result
    }
}