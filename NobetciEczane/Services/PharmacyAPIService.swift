import Foundation

actor PharmacyAPIService {
    private let apiKey = Constants.nosyAPIKey
    private let baseURL = Constants.nosyAPIURL

    func fetchPharmacies(city: String, district: String? = nil) async throws -> [Pharmacy] {
        var urlComponents = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem(name: "city", value: city.lowercased())]
        if let district = district, !district.isEmpty {
            queryItems.append(URLQueryItem(name: "district", value: district))
        }
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(PharmacyAPIResponse.self, from: data)

        if apiResponse.status != "success" {
            throw APIError.noData
        }

        return apiResponse.data ?? []
    }

    func fetchAllCities() async throws -> [String] {
        guard let url = URL(string: Constants.nosyCitiesURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10

        let (data, _) = try await URLSession.shared.data(for: request)
        struct CitiesResponse: Codable {
            let status: String
            let data: [CityItem]?
        }
        struct CityItem: Codable {
            let cities: String
        }
        let resp = try JSONDecoder().decode(CitiesResponse.self, from: data)
        return resp.data?.map { $0.cities } ?? []
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Geçersiz URL"
        case .invalidResponse: return "Sunucudan geçersiz yanıt"
        case .httpError(let code): return "HTTP hatası: \(code)"
        case .noData: return "Veri bulunamadı"
        case .decodingError: return "Veri çözümlenemedi"
        }
    }
}