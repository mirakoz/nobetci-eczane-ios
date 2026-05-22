import SwiftUI

struct PharmacyListView: View {
    @StateObject private var viewModel = PharmacyListViewModel()
    @State private var showCityPicker = false
    @State private var showDistrictPicker = false
    @State private var searchText = ""

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
                    Menu {
                        Button {
                            showCityPicker = true
                        } label: {
                            Label("Şehir Değiştir", systemImage: "building.2")
                        }
                        if !viewModel.availableDistricts.isEmpty {
                            Button {
                                showDistrictPicker = true
                            } label: {
                                Label("İlçe Değiştir", systemImage: "map")
                            }
                        }
                        Divider()
                        Button {
                            Task {
                                PharmacyCache.shared.clearCache()
                                await viewModel.fetchForCity(
                                    viewModel.selectedCity,
                                    district: viewModel.selectedDistrict.isEmpty ? nil : viewModel.selectedDistrict
                                )
                            }
                        } label: {
                            Label("Yenile (Önbelleği Temizle)", systemImage: "arrow.clockwise")
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showCityPicker) {
                CityPickerSheet(viewModel: viewModel, isPresented: $showCityPicker)
            }
            .sheet(isPresented: $showDistrictPicker) {
                DistrictPickerSheet(viewModel: viewModel, isPresented: $showDistrictPicker)
            }
            .onAppear {
                if viewModel.pharmacies.isEmpty && !viewModel.isLoading {
                    viewModel.requestLocationPermission()
                    viewModel.requestLocation()
                    Task {
                        await viewModel.fetchDistricts(for: viewModel.selectedCity)
                        await viewModel.fetchForCity(viewModel.selectedCity)
                    }
                }
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

            Text("Aramak istediğiniz şehri seçin.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                showCityPicker = true
            } label: {
                Label("Şehir Seç", systemImage: "building.2")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)

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
            Section {
                ForEach(viewModel.pharmacies) { pharmacy in
                    NavigationLink(destination: PharmacyDetailView(pharmacy: pharmacy)) {
                        PharmacyCardView(pharmacy: pharmacy)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            } header: {
                HStack {
                    Text("\(viewModel.pharmacies.count) eczane")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if !viewModel.selectedCity.isEmpty {
                        Text(viewModel.selectedCity)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    if !viewModel.selectedDistrict.isEmpty {
                        Text("/ \(viewModel.selectedDistrict)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .textCase(nil)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchForCity(
                viewModel.selectedCity,
                district: viewModel.selectedDistrict.isEmpty ? nil : viewModel.selectedDistrict
            )
        }
    }
}

struct CityPickerSheet: View {
    @ObservedObject var viewModel: PharmacyListViewModel
    @Binding var isPresented: Bool
    @State private var selectedCity: String = ""
    @State private var isLoading = false

    private let topCities = ["İstanbul", "Ankara", "İzmir"]
    // BOLT: Move sortedCities to a static constant to avoid re-sorting on every view initialization
    private static let sortedCities: [String] = [
        "Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Aksaray", "Amasya", "Antalya",
        "Ardahan", "Artvin", "Aydın", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik",
        "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum",
        "Denizli", "Diyarbakır", "Düzce", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir",
        "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Iğdır", "Isparta",
        "Kahramanmaraş", "Karabük", "Karaman", "Kars", "Kastamonu", "Kayseri",
        "Kırıkkale", "Kırklareli", "Kırşehir", "Kilis", "Kocaeli", "Konya", "Kütahya", "Malatya",
        "Manisa", "Mardin", "Mersin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Osmaniye",
        "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Şanlıurfa", "Şırnak",
        "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Uşak", "Van", "Yalova", "Yozgat", "Zonguldak",
        "Kıbrıs KKTC"
    ].sorted()
    private var allCities: [String] { topCities + Self.sortedCities }

    var body: some View {
        NavigationStack {
            List(allCities, id: \.self) { city in
                Button {
                    selectedCity = city
                } label: {
                    HStack {
                        Text(city)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selectedCity == city || viewModel.selectedCity == city {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Şehir Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Seç") {
                        isPresented = false
                        Task {
                            viewModel.selectedDistrict = ""
                            await viewModel.fetchDistricts(for: selectedCity)
                            await viewModel.fetchForCity(selectedCity)
                        }
                    }
                    .disabled(selectedCity.isEmpty)
                }
            }
        }
        .presentationDetents([.large])
    }
}

struct DistrictPickerSheet: View {
    @ObservedObject var viewModel: PharmacyListViewModel
    @Binding var isPresented: Bool
    @State private var selectedDistrict: String = ""

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingDistricts {
                    ProgressView("İlçeler yükleniyor...")
                } else if viewModel.availableDistricts.isEmpty {
                    Text("Bu şehirde ilçe bulunamadı.")
                        .foregroundStyle(.secondary)
                } else {
                    List(viewModel.availableDistricts) { district in
                        Button {
                            selectedDistrict = district.cities
                        } label: {
                            HStack {
                                Text(district.cities)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if selectedDistrict == district.cities || viewModel.selectedDistrict == district.cities {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("İlçe Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Seç") {
                        isPresented = false
                        Task {
                            await viewModel.fetchForCity(
                                viewModel.selectedCity,
                                district: selectedDistrict.isEmpty ? nil : selectedDistrict
                            )
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if !viewModel.selectedDistrict.isEmpty {
                        Button("Filtreyi Kaldır") {
                            isPresented = false
                            Task {
                                await viewModel.fetchForCity(viewModel.selectedCity)
                            }
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    PharmacyListView()
}