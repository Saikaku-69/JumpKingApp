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
    //    @EnvironmentObject var bmidata: BmiData
    @ObservedObject var bmidata = BmiData.shared
    //加速test
    @State private var SpeedupButton:Bool = false
    
    @State private var StartButton:Bool = true
    @State private var GetItem:[Item] = []
    @State private var ItemCreatePositionY:CGFloat = 25
    //设置屏幕高度用判定deadline
    @State private var screenHeight: CGFloat = 0
    @State private var deadLine: CGFloat = 0
    //定时器：用来计算Item降落的动画
    @State private var downTimer: Timer?
    @State private var realTimeWeight:Int = 0
    //
    @State private var mainObFrame:CGFloat = 100
    @State private var mainObPositionX: CGSize = .zero
    @GestureState private var dragObPositionX: CGSize = .zero
    @State private var mainObPostionY: CGFloat = UIScreen.main.bounds.height - 100
    
    @State private var lifeCount:Int = 0
    @State private var GameStart:Bool = false
    @State private var showRuleSheet:Bool = false
    
    //ゲーム時間タイマー
    @State private var GameTimer: Timer?
    @State private var GameTimeCount: Double = 60
    @State private var GameOverResult:Bool = false
    
    //ゲーム終了後のBMI計算
    @State private var lastBMI: Double = 0.0
    //gesture禁止
    @State private var GestureStop:Bool = true
    
    var body: some View {
        ZStack {
//            GeometryReader { geometry in
//                Image("bkbg1")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//                    .edgesIgnoringSafeArea(.all)
//            }
            VStack {
                HStack {
                    Text("\(bmidata.playerName)の体重:")
                    Text("\(realTimeWeight)")
                        .foregroundColor(.red)
                    Text("KG")
                }
                HStack {
                    Text("BMI:")
                    Text("\(lastBMI,specifier: "%.2")")
                }
            }
            .fontWeight(.bold)
            .offset(y: -350)
            .frame(width:UIScreen.main.bounds.width)
            if StartButton {
                VStack {
                    //rule
                    Button(action: {
                        showRuleSheet = true
                    }) {
                        Text("ルール紹介")
                            .padding()
                            .background(Color.ruleColor)
                            .cornerRadius(15)
                    }
                    Button(action: {
                        GestureStop = false
                        StartButton = false
                        GameStart = true
                        //掉落逻辑
                        gaming()
                        
                        //开始计时
                        GameTime()
                    }) {
                        Text("ゲーム開始")
                    }
                    .padding()
                    .background(Color.startColor)
                    .cornerRadius(15)
                }
                .foregroundColor(.white)
                .padding()
                .background(.clear)
                .cornerRadius(15)
            }
            ZStack {
                Image("SampleChara")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: mainObFrame + 30)
                    .position(x: mainObPositionX.width + dragObPositionX.width,y: mainObPostionY - 15)
                Image("bucket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: mainObFrame)
                    .position(x: mainObPositionX.width + dragObPositionX.width,y: mainObPostionY)
            }
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
            .disabled(GestureStop)
            ForEach(GetItem) { item in
                //itemImage
                Image(item.ImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:ItemWidth,height:ItemHeight)
                    .position(item.Position)
            }
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
            
            //ゲーム時間
            Gauge(value: GameTimeCount, in: 0...60) {
                Text("\(Int(GameTimeCount))")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(Color.red)
            .offset(x:-140,y:-320)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            screenHeight = UIScreen.main.bounds.height
            deadLine = screenHeight
            mainObPositionX.width += screenHeight / 4 - mainObFrame / 6
            
            //入力した体重をこちのViewに代入、ゲーム終了した時また計算する。
            realTimeWeight = Int(bmidata.weight)
        }
        .onDisappear {
            downTimer?.invalidate()
            GameTimer?.invalidate()
        }
        .sheet(isPresented: $showRuleSheet) {
            BurgerKingRuleView()
                .presentationDetents([.fraction(0.6)])
        }
//        .alert(isPresented: $GameOverResult) {
//            Alert(title: Text("ゲーム終了"),
//                  message: Text("あなたの体重は\(Int(realTimeWeight))KGになりました。\nBMIは\(lastBMI,specifier: "%.2f")"),
//                  primaryButton: .default(Text("OK")) {
//                realTimeWeight = 0
////                mainObPositionX.width = screenHeight / 4 - mainObFrame / 6
//            },
//                  secondaryButton: .default(Text("もっとみる")) {
//            })
//        }
    }
    
    private func createItem() {
        let images = ["hamburger", "poo", "vagetable"]
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
                    realTimeWeight += 1
                    GetItem.remove(at: index)
                } else if itemName.ImageName == "vagetable" {
                    //野菜
                    realTimeWeight -= 1
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
        if lifeCount == 5 || GameTimeCount <= 0 {
            GestureStop = true
            GameTimeStop()
            calculateBMI()
            StartButton = true
            GameStart = false
            GetItem.removeAll()
            lifeCount = 0
            GameTimeCount = 60
            GameOverResult = true
        }
    }
    private func GameTime() {
        GameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            GameTimeCount -= 1
            GameOver()
        }
    }
    private func GameTimeStop() {
        GameTimer?.invalidate()
    }
    private func calculateBMI() {
        lastBMI = Double(realTimeWeight) / ((bmidata.height / 100 ) * (bmidata.height / 100))
    }
}

extension Color {
    static var ruleColor:Color {
        return Color(
            Color(hue: 0.5, saturation: 0.3, brightness: 0.8)
        )
    }
    static var startColor:Color {
        return Color(
            Color(hue: 0.6, saturation: 0.8, brightness: 0.6)
        )
    }
}

#Preview {
    BoomView()
}
