import Foundation

actor PharmacyAPIService {
    private let apiKey = Constants.nosyAPIKey
    private let baseURL = Constants.nosyAPIURL

    func fetchPharmacies(latitude: Double, longitude: Double) async throws -> [Pharmacy] {
        guard let url = URL(string: "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)") else {
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

        guard let pharmacies = apiResponse.data else {
            throw APIError.noData
        }

        return pharmacies
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