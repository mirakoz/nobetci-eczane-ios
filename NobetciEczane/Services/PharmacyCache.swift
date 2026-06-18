import Foundation

final class PharmacyCache {
    static let shared = PharmacyCache()

    private let cacheDir: URL
    private let ttlSeconds: TimeInterval = 2 * 60 * 60 // 2 hours
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDir = paths[0].appendingPathComponent("PharmacyCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    }

    // MARK: - Public API

    func cachedPharmacies(city: String, district: String?) -> (pharmacies: [Pharmacy], isStale: Bool) {
        let key = cacheKey(city: city, district: district)
        let fileURL = cacheDir.appendingPathComponent("\(key).json")
        let metaURL = cacheDir.appendingPathComponent("\(key).meta")

        guard let data = try? Data(contentsOf: fileURL),
              let meta = try? Data(contentsOf: metaURL),
              let timestamp = try? decoder.decode(CacheMeta.self, from: meta) else {
            return ([], true)
        }

        let pharmacies = (try? decoder.decode([Pharmacy].self, from: data)) ?? []
        let age = Date().timeIntervalSince(timestamp.date)
        let isStale = age > ttlSeconds

        return (pharmacies, isStale)
    }

    func cachePharmacies(_ pharmacies: [Pharmacy], city: String, district: String?) {
        let key = cacheKey(city: city, district: district)
        let fileURL = cacheDir.appendingPathComponent("\(key).json")
        let metaURL = cacheDir.appendingPathComponent("\(key).meta")

        guard let data = try? encoder.encode(pharmacies) else { return }
        let meta = CacheMeta(date: Date())
        guard let metaData = try? encoder.encode(meta) else { return }

        try? data.write(to: fileURL)
        try? metaData.write(to: metaURL)
    }

    func clearCache() {
        try? FileManager.default.removeItem(at: cacheDir)
        try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    }

    func cacheAge(city: String, district: String?) -> TimeInterval? {
        let key = cacheKey(city: city, district: district)
        let metaURL = cacheDir.appendingPathComponent("\(key).meta")

        guard let meta = try? Data(contentsOf: metaURL),
              let timestamp = try? decoder.decode(CacheMeta.self, from: meta) else {
            return nil
        }
        return Date().timeIntervalSince(timestamp.date)
    }

    // MARK: - Private

    private func cacheKey(city: String, district: String?) -> String {
        let c = city.slugified()
        let d = (district ?? "").slugified()
        return "\(c)_\(d)"
    }
}

private struct CacheMeta: Codable {
    let date: Date
}