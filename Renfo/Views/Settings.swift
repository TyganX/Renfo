import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") var appTheme: AppTheme = .system
    @AppStorage("selectedIcon") var selectedIcon: AppIcon = .default
    @AppStorage("appColor") var appColor: AppColor = .default
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    NavigationLink(value: AppTheme.system) {
                        Label("App Theme", systemImage: "paintbrush.pointed.fill")
                    }
                    
                    NavigationLink(value: AppColorSelectionView(selectedColor: $appColor)) {
                        Label("App Color", systemImage: "paintpalette.fill")
                    }
                    
                    // Add this NavigationLink for App Icon selection
                    NavigationLink(value: AppIconSelectionView(selectedIcon: $selectedIcon)) {
                        Label("App Icon", systemImage: "app.badge.fill")
                    }
                }
                
                Section(header: Text("BEAN BANDITS")) {
                    URLButtonInApp(label: "Website", systemImage: "globe", urlString: "https://www.beanbandits.net/")
                    
                    URLButton(label: "Discord", systemImage: "person.bubble.fill", urlString: "discord://discord.gg/bE5tkVdAt9")
                    
                    URLButton(label: "Telegram", systemImage: "paperplane.fill", urlString: "https://t.me/BeanBandits")
                }
            }
            .navigationTitle("Settings")
            
            // Define the navigation destination for ThemeSelectionView
            .navigationDestination(for: AppTheme.self) { theme in
                ThemeSelectionView(selectedTheme: $appTheme)
            }
            
            // Define the navigation destination for AppColorSelectionView
            .navigationDestination(for: AppColorSelectionView.self) { appColorSelectionView in
                appColorSelectionView
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

// Add a new view for AppColor selection
struct AppColorSelectionView: View, Hashable, Equatable {
    @Binding var selectedColor: AppColor // This binds to the appColor in SettingsView
    
    // Implement the hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(selectedColor)
    }
    
    // Equatable conformance
    static func == (lhs: AppColorSelectionView, rhs: AppColorSelectionView) -> Bool {
        lhs.selectedColor == rhs.selectedColor
    }
    
    var body: some View {
        List {
            Section(header: Text("App Color")) {
                ForEach(AppColor.allCases) { color in
                    HStack {
                        Circle()
                            .fill(color.color)
                            .frame(width: 24, height: 24)
                        Text(color.rawValue.capitalized)
                        Spacer()
                        if color == selectedColor {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedColor = color
                    }
                }
            }
        }
        .navigationBarTitle("App Color", displayMode: .inline)
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
            Section(header: Text("App Icon")) {
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

// Preview provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
