//
//  gameTime.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/20.
//

import SwiftUI

class GameTime: ObservableObject {
    @Published var playTime:Int = 60
    private var playTimer: Timer?
    
    func tick() {
        playTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.playTime > 0 {
                self.playTime -= 1
            } else {
                self.playTimer?.invalidate()
            }
        }
    }
}
