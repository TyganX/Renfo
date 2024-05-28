import SwiftUI

struct ContentView: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @StateObject private var listViewModel = FestivalListViewModel()

    var body: some View {
        TabView() {
            // Home Tab
            NavigationStack {
                FestivalListView()
                    .environmentObject(listViewModel)
            }
            .tabItem {
                Image(systemName: "building.columns")
                Text("Festivals")
            }

            // Map Tab
            NavigationStack {
                MapView()
            }
            .tabItem {
                Image(systemName: "map")
                Text("Map")
            }

            // Settings Tab
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
        }
        .accentColor(appColor.color)
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
