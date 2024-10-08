//
//  LoadingView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/28.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var TitleOpacity:Double = 0.0
    @State private var TitleSize:CGFloat = UIScreen.main.bounds.width
    @State private var TitleRotation: CGFloat = 0
    @State private var MoveToPlayerInfoView:Bool = false
    //
    @State private var firstTitle:Bool = false
    @State private var secondTitle:Bool = false
    @State private var lastTitle:Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack {
                    if firstTitle {
                        Text("日本電子専門学校")
                    }
                    if secondTitle {
                        Text("日専祭")
                    }
                    if lastTitle {
                        Text("食")
                            .font(.system(size: TitleSize))
                    }
                }
                .font(.system(size: adaptiveFontSize(for: geometry.size)))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(TitleOpacity)
                .rotationEffect(Angle(degrees: TitleRotation))
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            OpenningAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.linear(duration: 1.5)) {
                    TitleRotation += 720
                    TitleSize = 0
                    TitleOpacity = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        MoveToPlayerInfoView = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $MoveToPlayerInfoView) {
            PlayerInfoView()
        }
    }
    
    private func adaptiveFontSize(for size: CGSize) -> CGFloat {
        // 这里可以根据需要调整比例因子
        return min(size.width, size.height / 15)
    }
    
    private func OpenningAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            firstTitle = true
            TitleOpacity = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                firstTitle = false
                TitleOpacity = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    secondTitle = true
                    TitleOpacity = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        secondTitle = false
                        TitleOpacity = 0.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            TitleOpacity = 1.0
                            lastTitle = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}
