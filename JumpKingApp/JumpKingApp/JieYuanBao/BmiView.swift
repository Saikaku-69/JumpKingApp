//
//  BmiView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/04.
//

import SwiftUI
import Foundation

class BmiData: ObservableObject {
    @Published var playerName: String = ""
    @Published var playerHeight: Double = 0.0
    @Published var playerWeight: Double = 0.0
//    @Published var playerHeight: String = ""
//    @Published var playerWeight: String = ""
    
    var playerBmi:Double {
        if playerHeight > 0 {
            return playerWeight / ((playerHeight / 100) * (playerHeight / 100))
        }
        return 0.0
    }
}
