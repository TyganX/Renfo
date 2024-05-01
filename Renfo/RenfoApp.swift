//
//  RenfoApp.swift
//  Renfo
//
//  Created by Tyler Keegan on 4/30/24.
//

import SwiftUI
import SwiftData

@main
struct RenfoApp: App {
    @AppStorage("appTheme") var appTheme: AppTheme = .system // Add the app theme storage
    @AppStorage("selectedIcon") var selectedIcon: AppIcon = .default
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(determineColorScheme()) // Apply the preferred color scheme
        }
        .modelContainer(sharedModelContainer)
    }

    // Function to determine the color scheme based on the app theme setting
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

// Make sure to define the AppTheme enum if it's not already defined
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}

enum AppIcon: String, CaseIterable {
    case `default` = "AppIcon"
    case gold = "AppIcon-Gold"
    case red = "AppIcon-Red"
    // Add more cases for each alternate icon

    var displayName: String {
        switch self {
        case .default:
            return "Default"
        case .gold:
            return "Gold"
        case .red:
            return "Red"
        // Add more display names for each case
        }
    }

    var iconName: String? {
        // For the default case, return nil to use the original icon
        self == .default ? nil : self.rawValue
    }
}


