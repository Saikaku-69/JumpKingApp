//
//  CGSizeTestView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/27.
//

import SwiftUI

struct CGSizeTestView: View {
    @State private var defaultOffset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var backHomePage: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                backHomePage = true
            }) {
                Text("back")
            }
            Spacer()
            Rectangle()
                .fill(Color.green)
                .frame(width: 50, height: 50)
                .offset(x: defaultOffset.width + dragOffset.width, y: defaultOffset.height + dragOffset.height)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation // 更新 dragOffset
                        }
                        .onEnded { value in
                            defaultOffset.width += value.translation.width // 累加当前拖动的位移
                            defaultOffset.height += value.translation.height
                        }
                )
            Spacer()
        }
        .fullScreenCover(isPresented: $backHomePage) {
            FrontView()
        }
    }
}

#Preview {
    CGSizeTestView()
}
