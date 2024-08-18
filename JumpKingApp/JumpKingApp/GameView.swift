//
//  GameView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/18.
//

import SwiftUI

struct GameView: View {
    
    @State private var isStart = true
    @State private var isGame = false
    
    //disabled
    @State private var isDead = true
    //結果出すAlert
    @State private var showAlert = false
    //Rectangle作り
    //    @State private var rectangles: [CGFloat] = []
    @State private var rectangles: [(position: CGFloat, color: Color)] = []
    
    @State private var dogY:CGFloat = 280
    @State private var rectX:CGFloat = 600
    //障害物移動タイマー
    @State private var timer: Timer?
    
    var body: some View {
        
        VStack {
            Spacer()
            //ゲーム画面Size
            ZStack {
                //startボタン
                if isStart {
                    Button(action: {
                        
                        isStart = false
                        isDead = false
                        
                        isGame = true
                        
                        Loop()
                    }) {
                        Text("GO!!")
                            .font(.system(size:50))
                            .padding()
                            .foregroundColor(.white)
                            .background(.black)
                    }
                }
                //Player
                Image("dog")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:50,height: 50)
                    .position(x:100, y: dogY)
                //障害物
                ForEach(rectangles, id: \.position) { rect in
                    Rectangle()
                        .fill(rect.color)
                        .frame(width:50,height: 50)
                        .position(x:rectX, y: 275)
                        .onChange(of: rectX) {
                            //判定
                            checkMove()
                        }
                }
                
            }
            .frame(width:UIScreen.main.bounds.width,height: 300)
            .border(.gray)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Game Over"),
                      message: Text("Score:"),
                      dismissButton: .default(Text("OK")) {
                    timer?.invalidate()
                    rectangles.removeAll()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isStart = true
                    }
                })
            }
            
            Spacer()
            //JumpButton
            Button(action: {
                jump()
                isDead = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isDead = false
                }
            }) {
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .opacity(0.8)
                        .frame(width:80,height:40)
                        .cornerRadius(8)
                    Text("JUMP!")
                        .foregroundColor(.black)
                        .padding()
                }
            }.disabled(isDead)
        }
        .frame(height:600)
    }
    
    //障害物作成
    private func createRectangle() {
        let color = Color.randomColor
        if isGame {
            rectangles.append((position: 600, color: color))
        }
    }
    //障害物削除
    private func delectRectangle() {
        rectangles.removeAll()
    }
    //
    private func restRectangle() {
        rectangles.removeAll()
        if isGame {
            rectX = 600
        }
    }
    //Rectangleループ
    private func Loop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            restRectangle()
            createRectangle()
            Move()
            Loop()
        }
    }
    //障害物移動
    private func Move() {
        if isGame {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.01,repeats: true) { _ in
                if rectX > 0 {
                    rectX -= 3
                    checkMove()
                } else {
                    //
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    //被るか判定
    private func checkMove() {
        let dogPosi = CGRect(x:100, y: dogY, width: 50, height: 50)
        let rectPosi = CGRect(x:rectX, y: 280, width: 50, height: 50)
        
        if dogPosi.intersects(rectPosi) {
            showAlert = true
            stopTimer()
            isGame = false
        }
    }
    //playerMove
    private func jump() {
        withAnimation(.easeInOut(duration: 0.5)) {
            dogY -= 80
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    dogY += 80
                }
            }
        }
    }
}

extension Color {
    static var randomColor: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

#Preview {
    GameView()
}
