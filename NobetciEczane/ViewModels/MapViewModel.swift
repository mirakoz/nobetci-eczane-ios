import Foundation
import SwiftUI
import MapKit

@MainActor
class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var selectedPharmacy: Pharmacy?
    @Published var showDetailSheet = false

    func centerOnPharmacy(_ pharmacy: Pharmacy) {
        withAnimation {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: pharmacy.latitude, longitude: pharmacy.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
        selectedPharmacy = pharmacy
        showDetailSheet = true
    }

    func fitPharmacies(_ pharmacies: [Pharmacy]) {
        guard !pharmacies.isEmpty else { return }
        let lats = pharmacies.map { $0.latitude }
        let lons = pharmacies.map { $0.longitude }
        let minLat = lats.min() ?? 0
        let maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0
        let maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5 + 0.01,
            longitudeDelta: (maxLon - minLon) * 1.5 + 0.01
        )
        withAnimation {
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
}

import CoreLocation