import Foundation
import CoreLocation
import Combine

@MainActor
class PharmacyListViewModel: ObservableObject {
    @Published var pharmacies: [Pharmacy] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedCity: String = "İstanbul"
    @Published var selectedDistrict: String = ""
    @Published var availableDistricts: [District] = []
    @Published var isLoadingDistricts = false
    @Published var cacheAge: TimeInterval?

    private let apiService = PharmacyAPIService()
    private let locationService = LocationService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupLocationBinding()
    }

    private func setupLocationBinding() {
        locationService.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let loc = location else { return }
                // Ignore implausible locations (e.g., simulator default SF coords)
                if !LocationService.isPlausiblyInTurkey(loc) {
                    self?.userLocation = nil
                    return
                }
                self?.userLocation = loc
            }
            .store(in: &cancellables)
    }

    func requestLocationPermission() {
        locationService.requestPermission()
    }

    func requestLocation() {
        locationService.requestLocation()
    }

    var isAuthorized: Bool {
        locationService.isAuthorized
    }

    func fetchForCity(_ city: String, district: String? = nil) async {
        isLoading = true
        errorMessage = nil
        selectedCity = city
        selectedDistrict = district ?? ""
        cacheAge = PharmacyCache.shared.cacheAge(city: city, district: district)

        do {
            let result = try await apiService.fetchPharmacies(city: city, district: district)
            cacheAge = 0

            if let userLoc = userLocation {
                // Offload distance calculations and sorting to a background task
                // to keep the Main Actor responsive during these operations.
                let sortedResult = await Task.detached(priority: .userInitiated) {
                    var items = result
                    let userCoords = Coordinates(latitude: userLoc.latitude, longitude: userLoc.longitude)
                    for i in items.indices {
                        let pharmacyCoords = Coordinates(
                            latitude: items[i].latitude,
                            longitude: items[i].longitude
                        )
                        items[i].distance = userCoords.distance(to: pharmacyCoords)
                    }
                    items.sort { ($0.distance ?? 0) < ($1.distance ?? 0) }
                    return items
                }.value
                pharmacies = sortedResult
            } else {
                pharmacies = result
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func fetchDistricts(for city: String) async {
        isLoadingDistricts = true
        do {
            availableDistricts = try await apiService.fetchDistricts(city: city)
        } catch {
            availableDistricts = []
        }
        isLoadingDistricts = false
    }

    func fetchForCurrentLocation() async {
        guard userLocation != nil else {
            errorMessage = "Konum bilinmiyor"
            return
        }
        await fetchForCity("İstanbul")
    }
}
