//
//  ContentView.swift
//  Renfo
//
//  Created by Tyler Keegan on 4/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            CalendarView()
                .tabItem() {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            SettingsView()
                .tabItem() {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
