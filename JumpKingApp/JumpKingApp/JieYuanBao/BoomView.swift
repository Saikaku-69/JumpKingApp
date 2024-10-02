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
    
    @State private var lifeCount:Int = 0
    @State private var GameStart:Bool = false
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
            ZStack {
                Text("\(Score)")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .offset(x: 30, y: -350)
                Text("現在の体重:        KG")
                    .fontWeight(.bold)
                    .offset(y: -350)
            }
            .frame(width:UIScreen.main.bounds.width/2)
            if StartButton {
                Button(action: {
                    StartButton = false
                    GameStart = true
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
            HStack {
                ForEach(lifeCount..<5,id: \.self) { icon in
                    Image("bkheart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:20)
                }
                ForEach(0..<lifeCount,id: \.self) { icon in
                    Image("bkheartblack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:20)
                }
            }
            .offset(y:-300)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .border(.gray)
        .onAppear() {
            screenHeight = UIScreen.main.bounds.height
            deadLine = screenHeight
            mainObPositionX.width += 200
        }
        .onDisappear {
            downTimer?.invalidate()
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
        if GameStart {
            createItem()
            startFalling()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                gaming()
            }
        }
    }
    
    private func collision() {
        let newMainObjectPosition = CGPoint(x: mainObPositionX.width + dragObPositionX.width, y: mainObPostionY)
        let newMainObjectFrame = CGRect( x:newMainObjectPosition.x - 50,
                                         y:newMainObjectPosition.y,
                                         width: mainObFrame,
                                         height: 1)
        
        for index in GetItem.indices.reversed() {
            let itemRect = CGRect(x: GetItem[index].Position.x - ItemWidth / 2,
                                  y: GetItem[index].Position.y - ItemHeight / 2,
                                  width:ItemWidth,
                                  height:ItemHeight)
            if newMainObjectFrame.intersects(itemRect) {
                let itemName = GetItem[index]
                if itemName.ImageName == "hamburger" {
                    Score += 1
                    GetItem.remove(at: index)
                } else {
                    lifeCount += 1
                    GetItem.remove(at: index)
                    GameOver()
                }
            }
        }
    }
    
    private func GameOver() {
        if lifeCount == 5 {
            StartButton = true
            GameStart = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                GetItem.removeAll()
//            }
        }
    }
}

#Preview {
    BoomView()
}
