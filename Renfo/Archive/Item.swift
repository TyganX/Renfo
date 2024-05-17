//
//  Item.swift
//  Renfo
//
//  Created by Tyler Keegan on 4/30/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
