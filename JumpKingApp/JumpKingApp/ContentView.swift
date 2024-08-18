//
//  ContentView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/13.
//

import SwiftUI

struct ContentView: View {
    @State private var rectangle:CGFloat = 40
    
    @State private var dogPositionX:CGFloat = 100
    @State private var dogPositionY:CGFloat = 283
    @State private var rectanglePotionX:CGFloat = 440
    @State private var rectanglePotionY:CGFloat = 280
    
    @State private var timer: Timer?
    
    @State private var count:Int = 0
    @State private var rectangles: [CGFloat] = []
    
    @State private var isPlus:Bool = false
    @AppStorage("Score") private var score: Int = 0
    
    @State private var isResult:Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("(仮)BEST:\(score)")
                    .opacity(0.5)
                    .padding(.trailing)
            }
            Spacer()
            Text("Score:\(count)")
            
            Button(action: {
                create()
                withAnimation {
                    Move()
                }
            }) {
                Text("開始")
            }
            ZStack {
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
                Rectangle()
                    .fill(.red)
                    .opacity(0.3)
                    .frame(width:5,height: 30)
                    .position(x:300, y: 300)
                ZStack {
                    Rectangle()
                        .fill(.gray)
                        .opacity(0.3)
                        .frame(width:rectangle,height: rectangle)
                        .position(x:35, y: 280)
                    if isPlus {
                        Rectangle()
                            .fill(.black)
                            .frame(width:rectangle,height: rectangle)
                            .position(x:35, y: 280)
                    }
                }
            }
            .frame(width:UIScreen.main.bounds.width,height: 300)
            .border(.gray)
            Button(action: {
                jump()
            }) {
                Circle()
                    .frame(width:50)
            }
            .padding(.top,50)
        }
        .frame(height:600)
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
        rectanglePotionX = 440
    }
    
    private func Move() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.003, repeats: true) { _ in
            if rectanglePotionX > 35 {
                rectanglePotionX -= 1
                Cheak()
            } else if rectanglePotionX == 35 {
                rectanglePotionX = 440
                isPlus = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPlus = false
                }
                count += 100
            }
            gameResult()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func Cheak() {
        let dogFrame = CGRect(x:dogPositionX, y: dogPositionY, width: 50, height: 50)
        let rectangleFrame = CGRect(x:rectanglePotionX, y: rectanglePotionY, width:rectangle, height: rectangle)
        if dogFrame.intersects(rectangleFrame) {
            resetMove()
            //当たった時の結果
            count -= 50
            dogPositionX += 10
        }
    }
    
    
    private func jump() {
        withAnimation(.easeInOut(duration: 0.5)) {
            dogPositionY -= 80
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    dogPositionY += 80
                }
            }
        }
    }
    
    private func gameResult() {
        if count <= -500 || dogPositionX >= 300 {
            isResult = true
            stopTimer()
        }
    }
    
    private func resetGame() {
        count = 0
        dogPositionX = 100
        rectanglePotionX = 440
        rectangles.removeAll()
    }
}

#Preview {
    ContentView()
}
