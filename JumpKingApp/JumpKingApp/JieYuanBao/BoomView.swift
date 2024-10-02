//
//  BoomView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/02.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    var Position: CGPoint
    var ImageName: String
}

let ItemWidth: CGFloat = 50
let ItemHeight: CGFloat = 50

struct BoomView: View {
    
    @State private var StartButton:Bool = true
    @State private var GetItem:[Item] = []
    @State private var ItemCreatePositionY:CGFloat = 25
    //设置屏幕高度用判定deadline
    @State private var screenHeight: CGFloat = 0
    @State private var deadLine: CGFloat = 0
    //定时器：用来计算Item降落的动画
    @State private var downTimer: Timer?
    @State private var Score:Int = 0
    //
    @State private var mainObFrame:CGFloat = 100
    @State private var mainObPositionX: CGSize = .zero
    @GestureState private var dragObPositionX: CGSize = .zero
    @State private var mainObPostionY: CGFloat = 700
    var body: some View {
        ZStack {
            ForEach(GetItem) { item in
                //itemImage
                Image(item.ImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:ItemWidth,height:ItemHeight)
                    .position(item.Position)
            }
                Text("点数：\(Score)")
                    .fontWeight(.bold)
                    .offset(y: -350)
                
                if StartButton {
                    Button(action: {
                        StartButton = false
                        
                        //掉落逻辑
                        gaming()
                        
                        //开始计时
                        
                    }) {
                        Text("Hello, World!")
                    }
                }
            Image("bucket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: mainObFrame)
                .position(x: mainObPositionX.width + dragObPositionX.width,y: mainObPostionY)
                .gesture(
                    DragGesture()
                        .updating($dragObPositionX) { move, value, _ in
                            value = move.translation
                            collision()
                        }
                        .onEnded { value in
                            mainObPositionX.width += value.translation.width
                            collision()
                        }
                )
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .border(.gray)
        .onAppear() {
            screenHeight = UIScreen.main.bounds.height
            deadLine = screenHeight
        }
    }
    
    private func createItem() {
        let images = ["hamburger", "poo"]
        let randomX = CGFloat.random(in: 25...(UIScreen.main.bounds.width - ItemWidth/2))
        let randomImage = images.randomElement() ?? "hamburger"
        
        let newItem = Item(Position:CGPoint(x:randomX,y:ItemCreatePositionY), ImageName: randomImage)
        GetItem.append(newItem)
    }
    
    private func falling() {
        for index in GetItem.indices.reversed() {
            if GetItem[index].Position.y < deadLine {
                withAnimation(.linear) {
                    GetItem[index].Position.y += 1
                }
            } else {
                GetItem.remove(at: index)
            }
        }
    }
    
    private func startFalling() {
        downTimer?.invalidate()
        downTimer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { _ in
            falling()
            collision()
        }
    }
    
    private func gaming() {
        createItem()
        startFalling()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            gaming()
        }
    }
    
    private func collision() {
        let newMainObjectPosition = CGPoint(x: mainObPositionX.width + dragObPositionX.width, y: mainObPostionY)
        let newMainObjectFrame = CGRect( x:newMainObjectPosition.x - 50,
                                         y:newMainObjectPosition.y,
                                         width: mainObFrame,
                                         height: mainObFrame)
        
        for index in GetItem.indices.reversed() {
            let itemRect = CGRect(x: GetItem[index].Position.x - ItemWidth / 2,
                                  y: GetItem[index].Position.y - ItemHeight / 2,
                                  width:ItemWidth,
                                  height:ItemHeight)
            if newMainObjectFrame.intersects(itemRect) {
                GetItem.remove(at: index)
            }
        }
    }
}

#Preview {
    BoomView()
}
