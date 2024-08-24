//
//  ItemResult.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/24.
//

import Foundation

class ItemResult: ObservableObject {
    @Published var itemPosition:CGPoint = CGPoint(x:140,y:200)
    @Published var itemFrame:CGFloat = 30
}
