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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack(spacing:0) {
                    ForEach(0..<words.count, id: \.self) { word in
                        //如果字段存储在数组中，字母就会显示出来
                        if animatedIndices.contains(word) {
                            Text(words[word])
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .animation(.easeIn(duration: 0.3), value: animatedIndices)
                        }
                    }
                }
                .frame(width:UIScreen.main.bounds.width/2)
                Spacer()
                if ShowTitle {
//                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            Text("モバイルアプリケーション")
                            Text("開発科")
                        }
                        .frame(maxWidth: .infinity)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(TitleOpacity)
//                    }
                }
                Spacer()
                Text("李宰赫")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(TitleOpacity)
            }
            .frame(height:UIScreen.main.bounds.height/3)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                for index in 0..<words.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.4) {
                        animatedIndices.append(index) // 每隔0.5秒显示下一个文字
                        if words.count == animatedIndices.count {
                            ShowTitle = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.linear(duration:1.5)) {
                                    TitleOpacity += 1.0
                                    if TitleOpacity == 1.0 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
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
            BoomView()
        }
    }
}

#Preview {
    LoadingView()
}
