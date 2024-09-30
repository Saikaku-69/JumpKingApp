//
//  WheelView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/27.
//

import SwiftUI

struct WheelView: View {
    @State private var wheelPosition:CGPoint = CGPoint(x:200,y:600)
    private let initialPosition: CGPoint = CGPoint(x: 200, y: 600)
    
    @State private var Position:CGPoint = CGPoint(x:200,y:200)
    
    let minX:CGFloat = 100
    let maxX:CGFloat = 300
    
    let minY:CGFloat = 500
    let maxY:CGFloat = 700
    
//    let colors: [Color] = [.green, .blue]
    @State private var backHomePage:Bool = false
    
    @State private var Score:Int = 0
    
    var body: some View {
        //dead line
        ZStack {
            VStack {
                Button(action: {
                    backHomePage = true
                }) {
                    Text("スコア：\(Score)")
                }
                
                Spacer()
            }.frame(maxHeight: .infinity)
            
            Rectangle()
                .fill(.green)
                .frame(width:100,height:50)
                .position(wheelPosition)
                .offset(y:-300)
            
            //checkPostionLine
            VStack(spacing:0) {
//                ForEach(0..<2, id: \.self) { value in
                    ForEach(1...2,id: \.self) { _ in
                        Rectangle()
//                            .fill(colors[value])
                            .stroke(Color.red)
                            .frame(width:300,height:300/2)
                            .offset(y:220)
//                    }
                }
            }
            
            //用于
            Circle()
                .fill(.gray)
                .frame(width:100)
                .position(initialPosition)
                .shadow(radius:0.5)
                .opacity(0.8)
            //连接棒
            
            Circle()
                .frame(width:100)
                .position(wheelPosition)
                .opacity(0.8)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newX = min(max(value.location.x, minX),maxX)
                            let newY = min(max(value.location.y, minY),maxY)
                            //                            self.wheelPosition = value.location
                            self.wheelPosition = CGPoint(x: newX, y: newY)
//                            Move()
                        }
                        .onEnded { value in
                            self.wheelPosition = initialPosition
                        }
                )
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
//        .edgesIgnoringSafeArea(.all)
        .border(.gray)
        .fullScreenCover(isPresented: $backHomePage) {
            FrontView()
        }
        //dead line
    }
    
    private func Move() {
        if wheelPosition.y < 600 {
            withAnimation(.easeIn(duration: 1)) {
                Position.y -= 20
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    withAnimation(.easeOut(duration: 1)) {
//                        Position.y += 5
//                    }
//                }
            }
            
        }
    }
}

#Preview {
    WheelView()
}
