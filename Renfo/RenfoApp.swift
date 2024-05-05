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
    @AppStorage("appTheme") var appTheme: AppTheme = .system
    @AppStorage("selectedIcon") var selectedIcon: AppIcon = .default
    @AppStorage("appColor") var appColor: AppColor = .default

    
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
        // For the default case, return nil to use the original icon
        self == .default ? nil : self.rawValue
    }
}

// Define your AppColor enum with all the accent colors you want to offer
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
    
    // Add a computed property to get the actual Color value
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

