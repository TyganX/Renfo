//
//  RenfoApp.swift
//  Renfo
//
//  Created by Tyler Keegan on 4/30/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

// MARK: - Main Application Entry Point
@main
struct RenfoApp: App {
    // MARK: - App Storage Properties
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @AppStorage("selectedIcon") private var selectedIcon: AppIcon = .default
    @AppStorage("appColor") private var appColor: AppColor = .default
    
    // MARK: - State Object
    // SessionStore to manage user session state
    @StateObject private var sessionStore = SessionStore()

    // MARK: - Initializer
    init() {
        // Firebase configuration
        FirebaseApp.configure()
    }
    
    // MARK: - Scene Builder
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionStore) // Provide sessionStore to the views
                .preferredColorScheme(determineColorScheme()) // Apply color scheme based on user preference
        }
    }

    // MARK: - Helper Methods
    // Determine the color scheme based on the app theme setting
    private func determineColorScheme() -> ColorScheme? {
        switch appTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}

// MARK: - Enumerations
// Define the AppTheme enum for theme settings
enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: String { self.rawValue }
}

// Define the AppIcon enum for app icon customization
enum AppIcon: String, CaseIterable {
    case `default` = "AppIcon"
    case chalice = "AppIcon-Chalice"
    case gold = "AppIcon-Gold"
    case pink = "AppIcon-Pink"
    // Add more cases for each alternate icon

    var displayName: String {
        switch self {
        case .default:
            return "Default"
        case .chalice:
            return "Chalice"
        case .gold:
            return "Gold"
        case .pink:
            return "Pink"
        // Add more display names for each case
        }
    }

    var iconName: String? {
        self == .default ? nil : self.rawValue
    }
}

// Define the AppColor enum for accent color customization
enum AppColor: String, CaseIterable, Identifiable, Hashable {
    case `default` = "Default"
    case royalOrange = "Royal Orange"
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case purple = "Purple"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .default:
            return Color.primary
        case .royalOrange:
            return Color("AccentColor-RoyalOrange")
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        case .purple:
            return .purple
        }
    }
}

// MARK: - Session Management
// SessionStore class to manage user authentication state
class SessionStore: ObservableObject {
    @Published var isUserSignedIn: Bool = false
    @Published var userName: String?
    @Published var userPhotoURL: String?
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isUserSignedIn = user != nil
            self?.userName = user?.displayName
            self?.userPhotoURL = user?.photoURL?.absoluteString
        }
    }
    
    // Computed property to get user initials from email
    var userInitials: String {
        guard let email = Auth.auth().currentUser?.email, let firstLetter = email.first else { return "N/A" }
        return String(firstLetter).uppercased()
    }
    
    // Computed property to get the user's email
    var userEmail: String {
        Auth.auth().currentUser?.email ?? "Not available"
    }
    
    // Create a new user account with email, password, and name
    func createAccount(email: String, password: String, name: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if error == nil {
                        self.userName = name
                        completion(true, nil)
                    } else {
                        completion(false, error)
                    }
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    // Sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserSignedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // Update the user's password
    func updatePassword(newPassword: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
        
        // Update the user's profile information
    func updateProfile(name: String, email: String, password: String, profilePicture: UIImage?, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, nil)
            return
        }
        
        // Update the user's name and profile picture
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        if let profilePicture = profilePicture {
            // Upload the profilePicture to Firebase Storage and get the download URL
        }
        changeRequest.commitChanges { error in
            if let error = error {
                completion(false, error)
            } else {
                // Update the user's email and password
                user.sendEmailVerification(beforeUpdatingEmail: email) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        user.updatePassword(to: password) { error in
                            if let error = error {
                                completion(false, error)
                            } else {
                                self.userName = name
                                completion(true, nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
