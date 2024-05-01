//
//  Calendar.swift
//  Renfo
//
//  Created by Tyler Keegan on 4/30/24.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @State private var showAlert = false  // State variable to control the alert visibility

    var body: some View {
        NavigationStack {
            List {
                Image(systemName: "theatermasks")
                    .symbolRenderingMode(.hierarchical)
                
                Image(systemName: "phone.fill")
                    .symbolRenderingMode(.multicolor)
            }
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    CalendarView()
}
