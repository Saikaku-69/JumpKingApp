//
//  LoadingView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/28.
//

import SwiftUI

struct LoadingView: View {
    let words = ["W", "e", "l", "c", "o", "m", "e"]
    //用于存储已动画显示的字段
    @State private var animatedIndices: [Int] = []
    
    @State private var ShowTitle:Bool = false
    @State private var TitleOpacity:Double = 0.0
    @State private var WordOpacity:Double = 0.0
    
    @State private var GoToMenu:Bool = false
    
    var body: some View {
        HStack(spacing:5) {
            ForEach(0..<words.count, id: \.self) { word in
               //如果字段存储在数组中，字母就会显示出来
                if animatedIndices.contains(word) {
                    Text(words[word])
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .animation(.easeIn(duration: 0.3), value: animatedIndices)
                }
            }
        }
        .frame(width:UIScreen.main.bounds.width/2)
        VStack {
            if ShowTitle {
                Text("Jump Dog")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(TitleOpacity)
            }
        }
        .frame(maxHeight:30)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                for index in 0..<words.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                        animatedIndices.append(index) // 每隔0.5秒显示下一个文字
                        if words.count == animatedIndices.count {
                            ShowTitle = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.linear(duration:1)) {
                                    TitleOpacity += 1.0
                                    if TitleOpacity == 1.0 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            GoToMenu = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $GoToMenu) {
            FrontView()
        }
    }
}

#Preview {
    LoadingView()
}
