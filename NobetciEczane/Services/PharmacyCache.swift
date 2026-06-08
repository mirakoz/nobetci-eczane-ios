import Foundation

final class PharmacyCache {
    static let shared = PharmacyCache()

    private let cacheDir: URL
    private let ttlSeconds: TimeInterval = 2 * 60 * 60 // 2 hours

    // Reuse coders to avoid repeated allocations
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()

    private init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDir = paths[0].appendingPathComponent("PharmacyCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    }

    // MARK: - Public API

    func cachedPharmacies(city: String, district: String?) -> (pharmacies: [Pharmacy], isStale: Bool) {
        let key = cacheKey(city: city, district: district)
        let fileURL = cacheDir.appendingPathComponent("\(key).json")

        // Single disk I/O and single decoding step for both data and metadata
        guard let data = try? Data(contentsOf: fileURL),
              let entry = try? Self.decoder.decode(CacheEntry.self, from: data) else {
            return ([], true)
        }

        let age = Date().timeIntervalSince(entry.date)
        let isStale = age > ttlSeconds

        return (entry.pharmacies, isStale)
    }

    func cachePharmacies(_ pharmacies: [Pharmacy], city: String, district: String?) {
        let key = cacheKey(city: city, district: district)
        let fileURL = cacheDir.appendingPathComponent("\(key).json")

        let entry = CacheEntry(pharmacies: pharmacies, date: Date())
        guard let data = try? Self.encoder.encode(entry) else { return }

        // Single disk I/O operation
        try? data.write(to: fileURL)

        // Clean up old meta files if they exist from previous versions
        let metaURL = cacheDir.appendingPathComponent("\(key).meta")
        try? FileManager.default.removeItem(at: metaURL)
    }

    func clearCache() {
        try? FileManager.default.removeItem(at: cacheDir)
        try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    }

    func cacheAge(city: String, district: String?) -> TimeInterval? {
        let key = cacheKey(city: city, district: district)
        let fileURL = cacheDir.appendingPathComponent("\(key).json")

        guard let data = try? Data(contentsOf: fileURL),
              let entry = try? Self.decoder.decode(CacheEntry.self, from: data) else {
            return nil
        }
        return Date().timeIntervalSince(entry.date)
    }

    // MARK: - Private

    private func cacheKey(city: String, district: String?) -> String {
        let c = city.slugified()
        let d = (district ?? "").slugified()
        return "\(c)_\(d)"
    }
}

private struct CacheEntry: Codable {
    let pharmacies: [Pharmacy]
    let date: Date
}
