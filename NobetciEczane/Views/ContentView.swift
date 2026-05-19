import SwiftUI
import MapKit

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PharmacyListView()
                .tabItem {
                    Label("Eczaneler", systemImage: "list.bullet")
                }
                .tag(0)

            PharmacyMapView()
                .tabItem {
                    Label("Harita", systemImage: "map")
                }
                .tag(1)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}