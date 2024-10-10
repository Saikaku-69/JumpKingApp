//
//  GameStoryView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/09.
//

import SwiftUI

struct GameStoryView: View {
    @State private var fontOpacity1: CGFloat = 0.0
    @State private var fontOpacity2: CGFloat = 0.0
    @State private var fontOpacity3: CGFloat = 0.0
    @State private var fontOpacityTitle: CGFloat = 0.0
    @State private var MoveToPlayerInfoView: Bool = false
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("空から落ちてくる食物を...")
                    Spacer()
                }
                .opacity(fontOpacity1)
                    Spacer()
                HStack {
                    Text("食って..　　　　")
                }
                .font(.system(size:UIScreen.main.bounds.width/10))
                .opacity(fontOpacity2)
                Spacer()
                Text("そして!")
                    .opacity(fontOpacity3)
                Spacer()
                Text("「伝説のデブ」")
                    .font(.system(size:UIScreen.main.bounds.width/7))
                    .opacity(fontOpacityTitle)
                    .padding(.bottom,10)
                
                HStack {
                    Spacer()
                    Text("になろう!!")
                        .font(.system(size:UIScreen.main.bounds.width/18))
                        .opacity(fontOpacityTitle)
                }
                Spacer()
            }
            .fontWeight(.bold)
            .font(.system(size:UIScreen.main.bounds.width/15))
            .foregroundColor(.white)
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height/2)
//            .border(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $MoveToPlayerInfoView) {
            PlayerInfoView()
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                fontOpacityPlus()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                MoveToPlayerInfoView = true
            }
        }
    }
    private func fontOpacityPlus() {
        withAnimation(.linear(duration: 1)) {
            fontOpacity1 += 2.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.linear(duration: 1)) {
                fontOpacity2 += 2.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.linear(duration: 1)) {
                    fontOpacity3 += 2.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.linear(duration: 1)) {
                        fontOpacityTitle += 2.0
                    }
                }
            }
        }
    }
}

#Preview {
    GameStoryView()
}
