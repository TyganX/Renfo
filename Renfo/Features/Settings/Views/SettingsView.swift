import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @AppStorage("appTheme") var appTheme: AppTheme = .system
    @AppStorage("selectedIcon") var selectedIcon: AppIcon = .default
    @AppStorage("appColor") var appColor: AppColor = .default
    @EnvironmentObject var sessionStore: SessionStore
    @State private var isShowingLogin = false
    @State private var isShowingProfile = false
    
    
    var body: some View {
        Form {
            // Profile Header Section
            Section {
                if sessionStore.isUserSignedIn {
                    NavigationLink(destination: AccountView()) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                if let userName = sessionStore.userName { // Display the user's name if available
                                    Text(userName) // Now a computed property in SessionStore
                                        .font(.headline)
                                }
                                Text(sessionStore.userEmail) // Ensure this is a computed property in SessionStore
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } else {
                    NavigationLink(destination: AuthenticationView()) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill") // Directly use the system image
                                .resizable() // Make the image resizable
                                .scaledToFit() // Scale the image to fit
                                .frame(width: 60, height: 60) // Set the frame for the image
                                .foregroundColor(.gray) // Set the color for the image
                            VStack(alignment: .leading) {
                                Text("Guest")
                                    .font(.headline)
                                Text("Sign in")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Appearance")) {
                NavigationLink(value: AppTheme.system) {
                    Label("App Theme", systemImage: "paintbrush.pointed")
                }
                
                NavigationLink(value: AppColorSelectionView(selectedColor: $appColor)) {
                    Label("App Color", systemImage: "paintpalette")
                }
                
                NavigationLink(value: AppIconSelectionView(selectedIcon: $selectedIcon)) {
                    Label("App Icon", systemImage: "app")
                }
            }
            
            Section(header: Text("Other")) {
                NavigationLink(destination: AboutView()) {
                    Label("About", systemImage: "info.circle")
                }
                
                NavigationLink(destination: WishKitView()) {
                    Label("Feature Requests", systemImage: "lightbulb.max")
                }
                
                
                NavigationLink(destination: ComingSoonView()) {
                    Label("Rate App", systemImage: "star")
                }
                
                Button(action: {
                    let url = URL(string: "https://testflight.apple.com/join/WnvOF5Jg") // Replace with your app store link
                    let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                    }
                }) {
                    Label {
                        Text("Share App")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                NavigationLink(destination: BeanBandits()) {
                    Label("Bean Bandits", systemImage: "surfboard")
                }
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
            return "gear"
        case .light:
            return "sun.max"
        case .dark:
            return "moon"
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
//                        Image(icon.rawValue)
                        Image(icon.settingsImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onAppear {
//                                print("Attempting to load image: \(icon.rawValue)")
                                print("Attempting to load image: \(icon.settingsImageName)")
                            }
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

struct ComingSoonView: View {
    var body: some View {
        Text("Coming Soon")
    }
}

// Preview provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(SessionStore())
        }
    }
}
