//
//  OpennnigView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/07.
//

import SwiftUI

struct OpennnigView: View {
    @State private var loadingBar:Double = 0
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Text("F")
                        .rotationEffect(Angle(degrees: -30), anchor: .trailing)
                    ZStack {
                        Text("O")
                        Image("hamburger")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:25)
                    }
                    ZStack {
                        Text("O")
                        Image("french")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30)
                    }
                    Text("D")
                        .rotationEffect(Angle(degrees: 25), anchor: .leading)
                }
                    .font(.system(size:50))
                Text(" HUNTER")
                    .font(.system(size:30))
            }
            .fontWeight(.bold)
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height/(5/1))
            .border(.blue)
            VStack {
                
            }
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height/(5/3))
            .border(.red)
            
            VStack {
                //ゲージ
                Gauge(value:loadingBar,in:0...10) {
                }
                .tint(.orange)
                .padding(.horizontal)
            }
            .frame(height:UIScreen.main.bounds.height/(5/1))
            .border(.green)
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            loadingBarPlus()
        }
    }
    private func loadingBarPlus() {
            withAnimation(.linear(duration: 10)) {
                loadingBar += 10
            }
    }
}

#Preview {
    OpennnigView()
}
