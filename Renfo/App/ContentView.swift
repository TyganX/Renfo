import SwiftUI

@available(iOS 18.0, *)
struct ContentView: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @StateObject private var listViewModel = FestivalListViewModel()

    var body: some View {
        TabView {
            // Home Tab
            Tab("Festivals", systemImage: "building.columns") {
                NavigationStack {
                    FestivalListView()
                        .environmentObject(listViewModel)
                }
            }
            
            // Map Tab
            Tab("Map", systemImage: "map") {
                NavigationStack {
                    MapView()
                }
            }
            
            // Settings Tab
            Tab("Settings", systemImage: "gearshape.fill") {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .accentColor(appColor.color)
        .tabViewStyle(.sidebarAdaptable)
        
//        TabView() {
//            // Home Tab
//            NavigationStack {
//                FestivalListView()
//                    .environmentObject(listViewModel)
//            }
//            .tabItem {
//                Image(systemName: "building.columns")
//                Text("Festivals")
//            }
//            
//            // Map Tab
//            NavigationStack {
//                MapView()
//            }
//            .tabItem {
//                Image(systemName: "map")
//                Text("Map")
//            }
//
//            // Settings Tab
//            NavigationStack {
//                SettingsView()
//            }
//            .tabItem {
//                Image(systemName: "gearshape.fill")
//                Text("Settings")
//            }
//        }
//        .accentColor(appColor.color)
    }
}

// MARK: - Preview Provider
@available(iOS 18.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
