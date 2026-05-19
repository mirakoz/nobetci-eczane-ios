import Foundation
import CoreLocation
import Combine

@MainActor
class PharmacyListViewModel: ObservableObject {
    @Published var pharmacies: [Pharmacy] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedCity: String = ""
    @Published var selectedDistrict: String = ""

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

        do {
            var result = try await apiService.fetchPharmacies(city: city, district: district)
            if let userLoc = userLocation {
                let userCoords = Coordinates(latitude: userLoc.latitude, longitude: userLoc.longitude)
                for i in result.indices {
                    let pharmacyCoords = Coordinates(
                        latitude: result[i].latitude,
                        longitude: result[i].longitude
                    )
                    result[i].distance = userCoords.distance(to: pharmacyCoords)
                }
                result.sort { ($0.distance ?? 0) < ($1.distance ?? 0) }
            }
            pharmacies = result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func fetchForCurrentLocation() async {
        guard let loc = userLocation else {
            errorMessage = "Konum bilinmiyor"
            return
        }
        // For now, default to Istanbul (user can change via search)
        await fetchForCity("İstanbul")
    }
}