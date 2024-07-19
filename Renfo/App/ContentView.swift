import SwiftUI

struct ContentView: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @StateObject private var listViewModel = FestivalListViewModel()

    var body: some View {
        // MARK: - iOS 18 Tab View
        TabView {
            // Festivals Tab
            Tab("Festivals", systemImage: "crown") {
                NavigationStack {
                    FestivalListView()
                        .environmentObject(listViewModel)
                }
            }
            
            // Map Tab
            Tab("Map", systemImage: "map") {
                NavigationStack {
                    MapView()
                        .environmentObject(listViewModel)
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
//        .environment(\.font, Font.system(design: .rounded))
        .tabViewStyle(.sidebarAdaptable)
    }
}

// MARK: - Preview Provider
#Preview {
    ContentView()
        .environmentObject(SessionStore())
}
