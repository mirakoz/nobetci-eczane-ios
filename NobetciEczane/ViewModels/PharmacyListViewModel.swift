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
        selectedCity = city
        selectedDistrict = district ?? ""

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
        guard let loc = userLocation else {
            errorMessage = "Konum bilinmiyor"
            return
        }
        await fetchForCity("İstanbul")
    }
}
