//
//  FrontView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/20.
//

import SwiftUI

struct FrontView: View {
    @State private var isPlay:Bool = false
    @State private var roketPosition:CGPoint = CGPoint(x:200,y:45)
    @State private var isWait:Bool = false
    @State private var isFire:Bool = false
    
    var body: some View {
        Spacer()
        VStack {
            Button(action: {
                isWait = true
                roketMoveY()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    isPlay = true
                    isWait = false
                }
            }) {
                Image("playButton")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:130)
            }
            .disabled(isWait)
        }
        .fullScreenCover(isPresented: $isPlay) {
            ContentView()
        }
        Spacer()
        ZStack {
            HStack(spacing: 0) {
                ForEach(1...2, id: \.self) { _ in
                    Image("ground")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
            }
                .offset(y:65)
            
            if isFire {
                Image("fire")
                    .position(x:200,y:12)
            }
            
            Image("roket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .position(roketPosition)
            
        }.frame(width:200,height:100)
    }
    
    //    private func roketMoveX() {
    //
    //        withAnimation(.linear(duration: 0.01)) {
    //            roketPosition.x -= 10
    //        }
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
    //            withAnimation(.linear(duration: 0.02)) {
    //                roketPosition.x += 20
    //            }
    //        }
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
    //            withAnimation(.linear(duration: 0.02)) {
    //                roketPosition.x -= 20
    //            }
    //        }
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
    //            withAnimation(.linear(duration: 0.01)) {
    //                roketPosition.x += 10
    //            }
    //        }
    //    }
    
    private func roketMoveY() {
        withAnimation(.easeIn(duration: 1.0)) {
            roketPosition.y += 45
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 1)) {
                roketPosition.y -= 905
                fire()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            roketPosition.y = 300
            withAnimation(.linear(duration: 1)) {
                roketPosition.y -= 255
            }
        }
    }
    
    private func fire() {
        isFire = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.linear(duration: 1.0)) {
                isFire = false
            }
        }
    }
}

#Preview {
    FrontView()
}
