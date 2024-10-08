//
//  FrontView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/20.
//

import SwiftUI

struct FrontView: View {
    @State private var isPlay:Bool = false
    @State private var roketPosition:CGPoint = CGPoint(x:200,y:185)
    @State private var firePosition:CGPoint = CGPoint(x:200,y:155)
    @State private var isWait:Bool = false
    //
    @State private var isFire:Bool = false
    @State private var ruleSheet:Bool = false
    @State private var ModeChange:Bool = false
    
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
            //Item&rule紹介
            Button(action: {
                ruleSheet = true
            }) {
                Image("menuButton")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:130)
            }
            .disabled(isWait)
            Button(action: {
                ModeChange = true
            }) {
                Image("next")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
            }
            .disabled(isWait)
        }
        .fullScreenCover(isPresented: $isPlay) {
            ContentView()
        }
        .fullScreenCover(isPresented: $ModeChange) {
            NewModeView()
        }
        .sheet(isPresented: $ruleSheet) {
                MenuView()
                .presentationDetents([.fraction(0.7)])
                .presentationDetents([.medium])
        }
        Spacer()
        ZStack {
            HStack {
                Image("treeL")
                Spacer()
                Image("treeR")
            }
            .offset(y:-155)
            //地面
            HStack(spacing: 0) {
                ForEach(1...2, id: \.self) { _ in
                    Image("ground")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
            }
                .offset(y:65)
            
            //roket
            if isFire {
                Image("fire")
                    .position(firePosition)
            }
            
            Image("roket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .position(roketPosition)
            
        }.frame(width:200,height:100)
        
        //
    }
    private func roketMoveY() {
        withAnimation(.easeIn(duration: 0.8)) {
            roketPosition.y += 45
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 1)) {
                roketPosition.y -= 905
                fire()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            roketPosition.y = 300
            withAnimation(.linear(duration: 0.8)) {
                roketPosition.y -= 120
            }
        }
    }
    
    private func fire() {
        isFire = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.linear(duration: 0.5)) {
                isFire = false
            }
        }
    }
}

#Preview {
    FrontView()
}
