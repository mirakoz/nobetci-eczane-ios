import Foundation
import CoreLocation

@MainActor
class PharmacyListViewModel: ObservableObject {
    @Published var pharmacies: [Pharmacy] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userLocation: CLLocationCoordinate2D?

    private let apiService = PharmacyAPIService()
    private let locationService = LocationService()

    var locationServicePublished: LocationService { locationService }

    init() {
        setupLocationBinding()
    }

    private func setupLocationBinding() {
        locationService.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let loc = location else { return }
                self?.userLocation = loc
                Task {
                    await self?.fetchPharmacies(lat: loc.latitude, lon: loc.longitude)
                }
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    func requestLocationPermission() {
        locationService.requestPermission()
    }

    func requestLocation() {
        locationService.requestLocation()
    }

    func fetchPharmacies(lat: Double, lon: Double) async {
        isLoading = true
        errorMessage = nil

        do {
            var result = try await apiService.fetchPharmacies(latitude: lat, longitude: lon)
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

    func fetchForCityDistrict(city: String, district: String) async {
        let coords = cityDistrictCoordinates(city: city, district: district)
        userLocation = coords
        await fetchPharmacies(lat: coords.latitude, lon: coords.longitude)
    }

    private func cityDistrictCoordinates(city: String, district: String) -> (latitude: Double, longitude: Double) {
        let locations: [String: (Double, Double)] = [
            "İstanbul": (41.0082, 28.9784),
            "Ankara": (39.9334, 32.8597),
            "İzmir": (38.4237, 27.1428),
            "Bursa": (40.1826, 29.0665),
            "Antalya": (36.8969, 30.7133)
        ]
        return locations[city] ?? (41.0082, 28.9784)
    }
}

import Combine