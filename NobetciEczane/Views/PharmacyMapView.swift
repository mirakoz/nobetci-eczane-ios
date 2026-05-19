import SwiftUI
import MapKit

struct PharmacyMapView: View {
    @StateObject private var viewModel = PharmacyListViewModel()
    @StateObject private var mapViewModel = MapViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: .constant(.region(mapViewModel.region))) {
                    ForEach(viewModel.pharmacies) { pharmacy in
                        Annotation(pharmacy.name, coordinate: CLLocationCoordinate2D(
                            latitude: pharmacy.latitude,
                            longitude: pharmacy.longitude
                        )) {
                            VStack(spacing: 4) {
                                Image(systemName: "cross.case.fill")
                                    .font(.title2)
                                    .foregroundStyle(.red)
                                    .background(Circle().fill(.white).padding(2))
                                Text(pharmacy.name)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(.white.opacity(0.9)))
                                    .clipShape(Capsule())
                            }
                            .onTapGesture {
                                mapViewModel.centerOnPharmacy(pharmacy)
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            if let loc = viewModel.userLocation {
                                mapViewModel.region = MKCoordinateRegion(
                                    center: loc,
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                )
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
            .navigationTitle("Harita")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mapViewModel.showDetailSheet) {
                if let pharmacy = mapViewModel.selectedPharmacy {
                    PharmacyDetailSheet(pharmacy: pharmacy)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

struct PharmacyDetailSheet: View {
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