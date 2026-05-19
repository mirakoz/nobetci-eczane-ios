import SwiftUI

struct PharmacyListView: View {
    @StateObject private var viewModel = PharmacyListViewModel()
    @State private var showManualSearch = false
    @State private var selectedCity = ""
    @State private var selectedDistrict = ""

    private let cities = ["İstanbul", "Ankara", "İzmir", "Bursa", "Antalya"]
    private let districtsByCity: [String: [String]] = [
        "İstanbul": ["Kadıköy", "Beşiktaş", "Şişli", "Üsküdar", "Fatih", "Bakırköy"],
        "Ankara": ["Çankaya", "Keçiören", "Mamak", "Yenimahalle", "Sincan"],
        "İzmir": ["Konak", "Karşıyaka", "Bornova", "Alsancak", "Buca"],
        "Bursa": ["Nilüfer", "Osmangazi", "Yıldırım", "Nilüfer"],
        "Antalya": ["Muratpaşa", "Konyaaltı", "Kepez", "Alanya"]
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.pharmacies.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else if viewModel.isLoading {
                    loadingView
                } else {
                    pharmacyList
                }
            }
            .navigationTitle("Nöbetçi Eczane")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showManualSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $showManualSearch) {
                manualSearchSheet
            }
        }
        .onAppear {
            if viewModel.userLocation == nil && viewModel.pharmacies.isEmpty {
                viewModel.requestLocationPermission()
                viewModel.requestLocation()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cross.case")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("Nöbetçi Eczane Bul")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Konumunuzu kullanarak size en yakın nöbetçi eczaneleri bulun.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                viewModel.requestLocationPermission()
                viewModel.requestLocation()
            } label: {
                Label("Konumumu Kullan", systemImage: "location.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)

            Button("Manuel Konum Seç") {
                showManualSearch = true
            }
            .font(.subheadline)
            .foregroundStyle(.blue)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Eczaneler bulunuyor...")
                .foregroundStyle(.secondary)
        }
    }

    private var pharmacyList: some View {
        List {
            ForEach(viewModel.pharmacies) { pharmacy in
                NavigationLink(destination: PharmacyDetailView(pharmacy: pharmacy)) {
                    PharmacyCardView(pharmacy: pharmacy)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
        }
        .listStyle(.plain)
        .refreshable {
            if let loc = viewModel.userLocation {
                await viewModel.fetchPharmacies(lat: loc.latitude, lon: loc.longitude)
            }
        }
    }

    private var manualSearchSheet: some View {
        NavigationStack {
            Form {
                Section("Şehir") {
                    Picker("Şehir Seçin", selection: $selectedCity) {
                        Text("Seçin").tag("")
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(.menu)
                }

                if !selectedCity.isEmpty {
                    Section("İlçe") {
                        Picker("İlçe Seçin", selection: $selectedDistrict) {
                            Text("Seçin").tag("")
                            ForEach(districtsByCity[selectedCity] ?? [], id: \.self) { district in
                                Text(district).tag(district)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Manuel Arama")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        showManualSearch = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ara") {
                        showManualSearch = false
                        Task {
                            await viewModel.fetchForCityDistrict(city: selectedCity, district: selectedDistrict)
                        }
                    }
                    .disabled(selectedCity.isEmpty || selectedDistrict.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    PharmacyListView()
}