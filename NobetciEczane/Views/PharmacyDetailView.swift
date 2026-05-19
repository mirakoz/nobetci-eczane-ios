import SwiftUI
import MapKit

struct PharmacyDetailView: View {
    let pharmacy: Pharmacy

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                mapPreview
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 16) {
                    infoSection
                    actionButtons
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(pharmacy.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var mapPreview: some View {
        Map(initialPosition: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: pharmacy.latitude, longitude: pharmacy.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))) {
            Marker(pharmacy.name, coordinate: CLLocationCoordinate2D(
                latitude: pharmacy.latitude,
                longitude: pharmacy.longitude
            ))
            .tint(.red)
        }
        .mapStyle(.standard)
        .allowsHitTesting(false)
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(pharmacy.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                if let distance = pharmacy.distance {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                        Text(String(format: "%.1f km", distance))
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
                }
            }

            Divider()

            Label(pharmacy.address, systemImage: "mappin.and.ellipse")
                .font(.body)
                .foregroundStyle(.secondary)

            Label(pharmacy.phone, systemImage: "phone.fill")
                .font(.body)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Nöbetçi")
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
            }
            .font(.subheadline)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                PhoneService.call(phoneNumber: pharmacy.phone)
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
                Label("Yol Tarifi Al", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            ShareLink(item: "\(pharmacy.name)\n\(pharmacy.address)\nTel: \(pharmacy.phone)") {
                Label("Paylaş", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    NavigationStack {
        PharmacyDetailView(pharmacy: Pharmacy(
            id: "1",
            name: "Ada Eczanesi",
            address: "Caferağa Mah. Moda Cad. No:42 Kadıköy, İstanbul",
            phone: "02163331234",
            latitude: 40.99,
            longitude: 29.02,
            distance: 1.3,
            isOpen: true
        ))
    }
}