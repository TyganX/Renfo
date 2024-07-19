//
//  RenfoApp.swift
//  Renfo
//
//  Created by Tyler Keegan on 4/30/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import Combine

// MARK: - Main Application Entry Point
@main
struct RenfoApp: App {
    // MARK: - App Storage Properties
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @AppStorage("selectedIcon") private var selectedIcon: AppIcon = .default
    @AppStorage("appColor") private var appColor: AppColor = .default
    
    // MARK: - State Object
    @StateObject private var sessionStore = SessionStore()
    
    init() {
        configureFirebase()
        configureFirestore()
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

    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    private func configureFirestore() {
        let settings = Firestore.firestore().settings
        settings.cacheSettings = PersistentCacheSettings()
        Firestore.firestore().settings = settings
    }
}

// MARK: - Enumerations
enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: String { self.rawValue }
}

enum AppIcon: String, CaseIterable {
    case `default` = "AppIcon"
    case chalice = "AppIcon-Chalice"
    case gold = "AppIcon-Gold"

    var displayName: String {
        switch self {
        case .default:
            return "Default"
        case .chalice:
            return "Chalice"
        case .gold:
            return "Gold"
        }
    }

    var iconName: String? {
        self == .default ? nil : self.rawValue
    }
    
    
    var settingsImageName: String {
        return rawValue.replacingOccurrences(of: "App", with: "")
    }
}

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
class SessionStore: ObservableObject {
    @Published var isUserSignedIn: Bool = false
    @Published var userName: String?
    @Published var userPhotoURL: String?
    var handle: AuthStateDidChangeListenerHandle?
    var cancellables = Set<AnyCancellable>()
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isUserSignedIn = user != nil
            self?.userName = user?.displayName
            self?.userPhotoURL = user?.photoURL?.absoluteString
        }
    }
    
    var userInitials: String {
        guard let email = Auth.auth().currentUser?.email, let firstLetter = email.first else { return "N/A" }
        return String(firstLetter).uppercased()
    }
    
    var userEmail: String {
        Auth.auth().currentUser?.email ?? "Not available"
    }
    
    func createAccount(email: String, password: String, name: String) -> AnyPublisher<Bool, Error> {
        Auth.auth().createUserPublisher(withEmail: email, password: password)
            .flatMap { authResult -> AnyPublisher<Void, Error> in
                let changeRequest = authResult.user.createProfileChangeRequest()
                changeRequest.displayName = name
                return Future { promise in
                    changeRequest.commitChanges { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            self.userName = name
                            promise(.success(()))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
        Auth.auth().signInPublisher(withEmail: email, password: password)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserSignedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func updatePassword(newPassword: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateProfile(name: String?, email: String?, profilePicture: UIImage?) -> AnyPublisher<Bool, Error> {
        guard let user = Auth.auth().currentUser else {
            return Fail(error: NSError(domain: "No user", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        var publishers = [AnyPublisher<Bool, Error>]()
        
        if let name = name {
            let namePublisher = updateUserName(name)
            publishers.append(namePublisher)
        }
        
        if let email = email, email != user.email {
            let emailPublisher = updateUserEmail(email)
            publishers.append(emailPublisher)
        }
        
        if let profilePicture = profilePicture {
            let profilePicturePublisher = updateUserProfilePicture(profilePicture)
            publishers.append(profilePicturePublisher)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    private func updateUserName(_ name: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    self.userName = name
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func updateUserEmail(_ email: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func updateUserProfilePicture(_ profilePicture: UIImage) -> AnyPublisher<Bool, Error> {
        Future { promise in
            self.uploadProfilePicture(image: profilePicture) { result in
                switch result {
                case .success(let url):
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = url
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            self.userPhotoURL = url.absoluteString
                            promise(.success(true))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func uploadProfilePicture(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image conversion failed", code: -1, userInfo: nil)))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_pictures/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}

// MARK: - Auth Extensions
extension Auth {
    typealias AuthResultPublisher = AnyPublisher<AuthDataResult, Error>
    
    func createUserPublisher(withEmail email: String, password: String) -> AuthResultPublisher {
        Future { promise in
            self.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signInPublisher(withEmail email: String, password: String) -> AuthResultPublisher {
        Future { promise in
            self.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
