import SwiftUI

struct PharmacyListView: View {
    @StateObject private var viewModel = PharmacyListViewModel()
    @State private var showCityPicker = false
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
                    Button {
                        showCityPicker = true
                    } label: {
                        Image(systemName: "building.2")
                    }
                }
            }
            .sheet(isPresented: $showCityPicker) {
                CityPickerSheet(viewModel: viewModel, isPresented: $showCityPicker)
            }
        }
        .onAppear {
            if viewModel.pharmacies.isEmpty && !viewModel.isLoading {
                viewModel.requestLocationPermission()
                viewModel.requestLocation()
                Task {
                    await viewModel.fetchForCity("İstanbul")
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
            await viewModel.fetchForCity(viewModel.selectedCity)
        }
    }
}

struct CityPickerSheet: View {
    @ObservedObject var viewModel: PharmacyListViewModel
    @Binding var isPresented: Bool
    @State private var selectedCity: String = ""
    @State private var selectedDistrict: String = ""
    @State private var isLoading = false

    let allCities = [
        "Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Aksaray", "Amasya", "Ankara", "Antalya",
        "Ardahan", "Artvin", "Aydın", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik",
        "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum",
        "Denizli", "Diyarbakır", "Düzce", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir",
        "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Iğdır", "Isparta", "İstanbul",
        "İzmir", "Kahramanmaraş", "Karabük", "Karaman", "Kars", "Kastamonu", "Kayseri",
        "Kırıkkale", "Kırklareli", "Kırşehir", "Kilis", "Kocaeli", "Konya", "Kütahya", "Malatya",
        "Manisa", "Mardin", "Mersin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Osmaniye",
        "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Şanlıurfa", "Şırnak",
        "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Uşak", "Van", "Yalova", "Yozgat", "Zonguldak",
        "Kıbrıs KKTC"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Şehir") {
                    Picker("Şehir Seçin", selection: $selectedCity) {
                        Text("Seçin").tag("")
                        ForEach(allCities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(.menu)
                }

                if !selectedCity.isEmpty {
                    Section("İlçe (Opsiyonel)") {
                        TextField("İlçe yazın veya boş bırakın", text: $selectedDistrict)
                            .textInputAutocapitalization(.never)
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
                    Button("Ara") {
                        isPresented = false
                        Task {
                            await viewModel.fetchForCity(selectedCity, district: selectedDistrict.isEmpty ? nil : selectedDistrict)
                        }
                    }
                    .disabled(selectedCity.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    PharmacyListView()
}