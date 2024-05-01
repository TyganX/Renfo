import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") var appTheme: AppTheme = .system // Bind the app theme storage
    @AppStorage("selectedIcon") var selectedIcon: AppIcon = .default
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    NavigationLink(value: AppTheme.system) {
                        Label("App Theme", systemImage: "paintbrush.pointed.fill")
                    }
                    
                    // Add this NavigationLink for App Icon selection
                    NavigationLink(value: AppIconSelectionView(selectedIcon: $selectedIcon)) {
                        Label("App Icon", systemImage: "app.badge.fill")
                    }
                }
                
                Section(header: Text("BEAN BANDITS").bold()) {
                    URLButtonInApp(label: "Website", systemImage: "globe", urlString: "https://www.beanbandits.net/")
                    
                    URLButton(label: "Discord", systemImage: "person.bubble.fill", urlString: "discord://discord.gg/bE5tkVdAt9")
                    
                    URLButton(label: "Telegram", systemImage: "paperplane.fill", urlString: "https://t.me/BeanBandits")
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(for: AppTheme.self) { theme in
                ThemeSelectionView(selectedTheme: $appTheme)
            }
            // Define the navigation destination for AppIconSelectionView
            .navigationDestination(for: AppIconSelectionView.self) { appIconSelectionView in
                appIconSelectionView
            }
        }
    }
}
    
struct ThemeSelectionView: View {
    @Binding var selectedTheme: AppTheme // This binds to the appTheme in SettingsView
    
    var body: some View {
        List {
            Section(header: Text("App Theme")) {
                ForEach(AppTheme.allCases) { theme in
                    HStack {
                        Label(theme.rawValue, systemImage: iconForTheme(theme))
                        Spacer()
                        if theme == selectedTheme {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTheme = theme
                    }
                }
            }
        }
        .navigationBarTitle("App Theme", displayMode: .inline)
    }
    
    // Function to return the corresponding system image name for each theme
    func iconForTheme(_ theme: AppTheme) -> String {
        switch theme {
        case .system:
            return "gear" // Example icon for system theme
        case .light:
            return "sun.max.fill" // Example icon for light theme
        case .dark:
            return "moon.fill" // Example icon for dark theme
        }
    }
}
    
// Define a new view for App Icon selection
struct AppIconSelectionView: View, Hashable {
    @Binding var selectedIcon: AppIcon
    
    // Implement the hash function for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(selectedIcon)
    }
    
    // Implement the equality function for Hashable conformance
    static func == (lhs: AppIconSelectionView, rhs: AppIconSelectionView) -> Bool {
        lhs.selectedIcon == rhs.selectedIcon
    }
    
    func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("App icon changed successfully!")
            }
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Select App Icon")) {
                ForEach(AppIcon.allCases, id: \.self) { icon in
                    HStack {
                        Image(uiImage: UIImage(named: icon.rawValue) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        Text(icon.displayName)
                        Spacer()
                        if icon == selectedIcon {
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture {
                        selectedIcon = icon
                        changeAppIcon(to: icon.iconName)
                    }
                }
            }
        }
        .navigationBarTitle("App Icons", displayMode: .inline)
    }
}

#Preview {
    SettingsView()
}
//struct ThemeSelectionView: View {
//    @Binding var selectedTheme: AppTheme // This binds to the appTheme in SettingsView
//
//    var body: some View {
//        List {
//            Section(header: Text("App Theme")) {
//                ForEach(AppTheme.allCases) { theme in
//                    HStack {
//                        Label((theme.rawValue), systemImage: "paintbrush.pointed.fill")
////                        Text(theme.rawValue)
//                        Spacer()
//                        if theme == selectedTheme {
//                            Image(systemName: "checkmark")
//                        }
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selectedTheme = theme
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("Appearance", displayMode: .inline)
//    }
//}
