import SwiftUI

struct ContentView: View {
    // Retrieve the selected app color
    @AppStorage("appColor") var appColor: AppColor = .default

    var body: some View {
        TabView() {
            // Home Tab
            NavigationStack {
                FestivalListView()
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
        .accentColor(appColor.color) // Apply the accent color to the TabView
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
