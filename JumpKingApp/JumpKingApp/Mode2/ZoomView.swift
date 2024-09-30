//
//  ZoomView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/27.
//

import SwiftUI

struct ZoomView: View {
    @State private var backHomePage: Bool = false
    @State private var scale: CGFloat = 1.0
    @GestureState private var dragScale: CGFloat = 1.0
    
    @State private var defaultOffset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        // 需要缩放的内容，例如图片
        Button(action: {
            backHomePage = true
        }) {
            Text("back")
        }
        VStack {
            Image("abokado")
                .resizable()
                .scaledToFit()
                .scaleEffect(scale * dragScale) // 应用缩放比例
                .offset(x:defaultOffset.width + dragOffset.width, y:defaultOffset.height + dragOffset.height)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .updating($dragScale) { value, state, _ in
                                state = value
                            }
                            .onEnded { value in
                                // 在手势结束时，将最终缩放值应用到 scale
                                scale *= value // 更新原始缩放比例
                            },
                        DragGesture()
                            .updating($dragOffset) { item, move, _ in
                                move = item.translation
                            }
                            .onEnded { item in
                                defaultOffset.width += item.translation.width
                                defaultOffset.height += item.translation.height
                            }
                    )
                )
                .frame(width: 300, height: 300)
        }
        .fullScreenCover(isPresented: $backHomePage) {
            FrontView()
        }
    }
}

#Preview {
    ZoomView()
}
