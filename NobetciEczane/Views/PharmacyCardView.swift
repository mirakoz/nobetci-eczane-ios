import SwiftUI

struct PharmacyCardView: View {
    let pharmacy: Pharmacy

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(pharmacy.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                if let distance = pharmacy.distance {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                        Text(String(format: "%.1f km", distance))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
                }
            }

            Text(pharmacy.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 12) {
                Button {
                    _ = PhoneService.call(phoneNumber: pharmacy.phone)
                } label: {
                    Label(pharmacy.phone, systemImage: "phone.fill")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.15))
                        .foregroundStyle(.green)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Button {
                    PhoneService.openDirections(
                        latitude: pharmacy.latitude,
                        longitude: pharmacy.longitude,
                        name: pharmacy.name
                    )
                } label: {
                    Label("Yol Tarifi", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.15))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    PharmacyCardView(pharmacy: Pharmacy(
        id: "1",
        name: "Ada Eczanesi",
        address: "Caferağa Mah. Moda Cad. No:42 Kadıköy, İstanbul",
        phone: "02163331234",
        latitude: 40.99,
        longitude: 29.02,
        distance: 1.3,
        isOpen: true
    ))
    .padding()
}