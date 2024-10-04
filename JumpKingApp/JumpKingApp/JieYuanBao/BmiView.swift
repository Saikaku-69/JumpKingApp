//
//  BmiView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/04.
//

import SwiftUI
import Foundation

class BmiData: ObservableObject {
    static let shared = BmiData()
    @Published var playerName: String = ""
    @Published var bmi: Double = 0.0
}
