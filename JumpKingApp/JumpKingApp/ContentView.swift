//
//  ContentView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/13.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var gameTime = GameTime()
    
    @State private var rectangle:CGFloat = 40
    
    @State private var dogPositionX:CGFloat = 100
    @State private var dogPositionY:CGFloat = 283
    @State private var rectanglePotionX:CGFloat = 640
    @State private var rectanglePotionY:CGFloat = 280
    
    @State private var timer: Timer?
    
    @State private var count:Int = 0
    @State private var rectangles: [CGFloat] = []
    
    @State private var isPlus:Bool = false
    @State private var isMinus:Bool = false
    @AppStorage("Score") private var score: Int = 0
    
    @State private var isResult:Bool = false
    @State private var isStop:Bool = true
    @State private var isOn:Bool = true
    
    var body: some View {
        VStack {
            
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("(仮)BEST:\(score)")
                            .opacity(0.5)
                            .padding(.trailing)
                    }
                    Text("GameTime:\(gameTime.playTime)")
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Spacer()
                    Text("Score:\(count)")
                    
                    HStack {
                        if isOn {
                            Button(action: {
                                gameTime.tick()
                                create()
                                withAnimation {
                                    Move()
                                }
                                isStop = false
                                isOn = false
                            }) {
//                                Text("開始")
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal)
                                Image("startButton")
                            }
                        }
                    }.frame(height:50)
                }
            }
            .frame(height:200)
            
            ZStack {
                Image("haikei0")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y:43)
                HStack {
                    Image("haikei1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Image("haikei2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .offset(y:43)
                Image("dog")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:rectangle,height: rectangle)
                    .position(x:dogPositionX, y: dogPositionY)
                ForEach(rectangles, id: \.self) { _ in
                    Rectangle()
                        .fill(.gray)
                        .frame(width:rectangle,height: rectangle)
                        .position(x:rectanglePotionX, y: rectanglePotionY)
                }
                //minusBox
                if isMinus {
                    ZStack {
                        Rectangle()
                            .fill(.red)
                            .frame(width:rectangle,height: rectangle)
                        Text("-50")
                            .foregroundColor(.white)
                    }
                    .position(x:rectanglePotionX, y: rectanglePotionY)
                }
                
//                Rectangle()
//                    .fill(.red)
//                    .opacity(0.3)
//                    .frame(width:5,height: 30)
//                    .position(x:300, y: 300)
                Image("sword")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:40)
                    .position(x:335, y: 280)
                ZStack {
                    Rectangle()
                        .fill(.gray)
                        .opacity(0.3)
                        .frame(width:rectangle,height: rectangle)
                        .position(x:35, y: 280)
                    if isPlus {
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .frame(width:rectangle,height: rectangle)
                            Text("+100")
                                .foregroundColor(.white)
                        }
                        .position(x:35, y: 280)
                    }
                }
            }
            .frame(width:UIScreen.main.bounds.width,height: 300)
            //            .border(.gray)
            ZStack {
                VStack(spacing: 0) {
                    ForEach(1...5, id: \.self) { _ in
                        HStack(spacing: 0) {
                            ForEach(1...3, id: \.self) { _ in
                                Image("mapGround")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                }
                .offset(y:35)
                //jumpButton
                Button(action: {
                    jump()
                    isStop = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isStop = false
                    }
                }) {
//                    Circle()
//                        .fill(.gray)
//                        .opacity(0.2)
//                        .frame(width:80)
                    Image("jumpButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:50)
                }
                .padding(.top)
                .disabled(isStop)
            }
            Spacer()
        }
        .background(Color.color)
        .frame(height:800)
        .alert(isPresented: $isResult) {
            Alert(title: Text("Game Over"), message: Text("Score: \(count)点"),
                  primaryButton: .default(Text("Play Again")) {
                resetGame()
            },
                  secondaryButton: .cancel())
        }
    }
    
    private func create() {
        rectangles.append(rectanglePotionX)
    }
    
    private func resetMove() {
        rectanglePotionX = 640
    }
    
    private func Move() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.003, repeats: true) { _ in
            if gameTime.playTime > 30 {
                if rectanglePotionX > 35 {
                    rectanglePotionX -= 1
                    Cheak()
                } else if rectanglePotionX <= 35 {
                    rectanglePotionX = 640
                    isPlus = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPlus = false
                    }
                    count += 100
                }
            } else {
                if rectanglePotionX > 35 {
                    rectanglePotionX -= 1.5
                    Cheak()
                } else if rectanglePotionX <= 35 {
                    rectanglePotionX = 640
                    isPlus = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPlus = false
                    }
                    count += 100
                }
            }
            gameResult()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func Cheak() {
        let dogFrame = CGRect(x:dogPositionX, y: dogPositionY, width: 50, height: 50)
        let rectangleFrame = CGRect(x:rectanglePotionX - 10, y: rectanglePotionY + 10, width:rectangle, height: rectangle)
        if dogFrame.intersects(rectangleFrame) {
            timer?.invalidate()
            MinusResult()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                resetMove()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    Move()
                }
                count -= 50
                dogPositionX += 10
                
            }
        }
    }
    // count > 1000時の判定
    //    private func speedUpCheak() {
    //            let dogFrame = CGRect(x:dogPositionX, y: dogPositionY, width: 50, height: 50)
    //            let rectangleFrame = CGRect(x:rectanglePotionX - 10, y: rectanglePotionY + 10, width:rectangle, height: rectangle)
    //            if dogFrame.intersects(rectangleFrame) {
    //                timer?.invalidate()
    //                MinusResult()
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //                    resetMove()
    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
    //                        Move()
    //                    }
    //                    count -= 50
    //                    dogPositionX += 10
    //            }
    //        }
    //    }
    
    private func MinusResult() {
        isMinus = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isMinus = false
        }
    }
    
    private func jump() {
        withAnimation(.easeInOut(duration: 0.3)) {
            dogPositionY -= 60
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    dogPositionY += 60
                }
            }
        }
    }
    
    private func gameResult() {
        if count <= -1000 || dogPositionX >= 300 || gameTime.playTime == 0 {
            isResult = true
            stopTimer()
            gameTime.tok()
        }
    }
    
    private func resetGame() {
        count = 0
        dogPositionX = 100
        rectanglePotionX = 440
        isOn = true
        gameTime.tok()
        gameTime.playTime = 60
        rectangles.removeAll()
    }
}

extension Color {
    static var color:Color {
        return Color(
            hue: 0.581, saturation: 0.447, brightness: 0.959
        )
    }
}
#Preview {
    ContentView()
}
