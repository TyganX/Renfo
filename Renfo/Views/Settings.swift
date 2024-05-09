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
        NavigationStack {
            Form {
                // Profile Header Section
                Section {
                    if sessionStore.isUserSignedIn {
                        NavigationLink(destination: ProfileView()) {
                            HStack(spacing: 15) {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 60, height: 60)
                                    .overlay(Text(sessionStore.userInitials)
                                        .font(.title2)
                                        .foregroundColor(.white))
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
                        NavigationLink(destination: SignInView()) {
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
                        Label("App Theme", systemImage: "paintbrush.pointed.fill")
                    }
                    
                    NavigationLink(value: AppColorSelectionView(selectedColor: $appColor)) {
                        Label("App Color", systemImage: "paintpalette.fill")
                    }
                    
                    NavigationLink(value: AppIconSelectionView(selectedIcon: $selectedIcon)) {
                        Label("App Icon", systemImage: "app.badge.fill")
                    }
                }
                
                Section(header: Text("Other")) {
                    NavigationLink(destination: ComingSoonView()) {
                        Label("About", systemImage: "info.circle.fill")
                    }
                    
                    NavigationLink(destination: BeanBandits()) {
                        Label("Bean Bandits", systemImage: "surfboard.fill")
                    }
                    
                    NavigationLink(destination: ComingSoonView()) {
                        Label("Rate App", systemImage: "star.fill")
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
                            Image(systemName: "square.and.arrow.up.fill")
                        }
                    }
                }
                
                // sign-up button
                Section {
                    if !sessionStore.isUserSignedIn {
                        NavigationLink(destination: SignUpView()) {
                            HStack {
                                Spacer()
                                Text("Don't have an account? Sign up")
//                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }
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
}

// MARK: - Subviews
// Sign Up Link View
private func signUpLink() -> some View {
    HStack {
        Text("Don't have an account?")
            .foregroundColor(.gray)
        NavigationLink(destination: SignUpView()) {
            Text("Sign Up")
                .foregroundColor(.blue)
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

struct ComingSoonView: View {
    var body: some View {
        Text("Coming Soon")
    }
}

// Preview provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SessionStore())
    }
}
