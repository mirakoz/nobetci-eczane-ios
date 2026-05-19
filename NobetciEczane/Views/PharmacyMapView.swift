import SwiftUI
import MapKit

struct PharmacyMapView: View {
    @StateObject private var viewModel = PharmacyListViewModel()
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedPharmacy: Pharmacy?
    @State private var showDetailSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                mapContent
                locationButton
            }
            .navigationTitle("Harita")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showDetailSheet) {
                if let pharmacy = selectedPharmacy {
                    PharmacyMapDetailSheet(pharmacy: pharmacy)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
            .onChange(of: selectedPharmacy) { _, newValue in
                if newValue != nil {
                    showDetailSheet = true
                }
            }
            .onAppear {
                if viewModel.pharmacies.isEmpty {
                    viewModel.requestLocationPermission()
                    viewModel.requestLocation()
                    Task {
                        await viewModel.fetchForCity(viewModel.selectedCity)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var mapContent: some View {
        Map(position: $position, selection: $selectedPharmacy) {
            ForEach(viewModel.pharmacies) { pharmacy in
                Annotation(pharmacy.name, coordinate: pharmacyCoordinate(pharmacy)) {
                    pharmacyAnnotationView(pharmacy)
                }
                .annotationTitles(.hidden)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onChange(of: viewModel.pharmacies) { _, newValue in
            if !newValue.isEmpty {
                fitPharmacies(newValue)
            }
        }
    }

    private func pharmacyCoordinate(_ pharmacy: Pharmacy) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: pharmacy.latitude, longitude: pharmacy.longitude)
    }

    @ViewBuilder
    private func pharmacyAnnotationView(_ pharmacy: Pharmacy) -> some View {
        VStack(spacing: 4) {
            pharmacyIcon
            pharmacyNameLabel(pharmacy)
        }
        .onTapGesture {
            selectedPharmacy = pharmacy
        }
    }

    private var pharmacyIcon: some View {
        Image(systemName: "cross.case.fill")
            .font(.title2)
            .foregroundStyle(.red)
            .background(
                Circle()
                    .fill(.white)
                    .padding(2)
            )
    }

    @ViewBuilder
    private func pharmacyNameLabel(_ pharmacy: Pharmacy) -> some View {
        Text(pharmacy.name)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(.white.opacity(0.9)))
            .clipShape(Capsule())
    }

    private var locationButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    if let loc = viewModel.userLocation {
                        position = .region(MKCoordinateRegion(
                            center: loc,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    }
                } label: {
                    Image(systemName: "location.fill")
                        .font(.body)
                        .padding(12)
                        .background(Circle().fill(.white))
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }

    private func fitPharmacies(_ pharmacies: [Pharmacy]) {
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
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.5),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.5)
        )
        position = .region(MKCoordinateRegion(center: center, span: span))
    }
}

struct PharmacyMapDetailSheet: View {
    let pharmacy: Pharmacy
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pharmacy.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    if let distance = pharmacy.distance {
                        Text("\(String(format: "%.1f", distance)) km uzaklıkta")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Label(pharmacy.address, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Label(pharmacy.phone, systemImage: "phone.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                Button {
                    _ = PhoneService.call(phoneNumber: pharmacy.phone)
                } label: {
                    Label("Ara", systemImage: "phone.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    PhoneService.openDirections(
                        latitude: pharmacy.latitude,
                        longitude: pharmacy.longitude,
                        name: pharmacy.name
                    )
                } label: {
                    Label("Yol Tarifi", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding()
    }
}

#Preview {
    PharmacyMapView()
}