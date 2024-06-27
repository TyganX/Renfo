//
//  AboutView.swift
//  Renfo
//
//  Created by Tyler Keegan on 5/12/24.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        Image(systemName: "timelapse")
            .font(.system(size: 64))
            .symbolRenderingMode(.multicolor)
//            .symbolEffect(.variableColor)
            .symbolEffect(.variableColor.iterative)
//            .symbolEffect(.variableColor.hideInactiveLayers.reversing)
        Text("Coming Soon")
    }
}

// MARK: - Preview Provider
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AboutView()
        }
    }
}
