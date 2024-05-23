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
        
            // Vendors Tab
            NavigationStack {
                VendorListView()
            }
            .tabItem {
                Image(systemName: "person.2")
                Text("Vendors")
            }
            
            // Calendar Tab
            NavigationStack {
                CalendarView()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Calendar")
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
