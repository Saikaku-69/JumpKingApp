//
//  RectTestView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/18.
//

import SwiftUI

struct RectTestView: View {
    //    @State private var rect1Posi:CGPoint = CGPoint(x:100,y:280)
    //    @State private var rect2Posi:CGPoint = CGPoint(x:300,y:280)
    @State private var rect1Posi:CGFloat = 280
    @State private var rect2Posi:CGFloat = 300
    
    @State private var showAlert = false
    @State private var timer: Timer?
    @State private var rectangles: [CGFloat] = []
    var body: some View {
        Button(action: {
            //            Loop()
        }) {
            Text("test")
        }
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width:50,height: 50)
                .position(x:100, y: rect1Posi)
            
            ForEach(rectangles, id: \.self) { name in
                Rectangle()
                    .fill(.red)
                    .frame(width:50,height: 50)
                    .position(x:rect2Posi, y: 280)
                    .onChange(of: rect2Posi) {
                        checkMove()
                    }
            }
            
        }
        .frame(width:UIScreen.main.bounds.width,height: 305)
        .border(.gray)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over"),
                  message: Text(""),
                  dismissButton: .default(Text("OK")))
        }
        Button(action: {
            jump()
        }) {
            Text("jump")
        }
        .padding(.top,50)
    }
    
    private func Move() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            withAnimation {
                if rect2Posi > 0 {
                    rect2Posi -= 1
                    checkMove()
                } else {
                    timer?.invalidate()
                }
            }
        }
    }
    
    private func checkMove() {
        let rect1Frame = CGRect(x:100, y: rect1Posi, width:50,height:50)
        let rect2Frame = CGRect(x:rect2Posi, y: 280, width:50,height:50)
        if rect1Frame.intersects(rect2Frame) {
            showAlert = true
            timer?.invalidate()
        }
    }
    
    private func jump() {
        withAnimation {
            rect1Posi -= 80
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    rect1Posi += 80
                }
            }
        }
    }
    
    private func startGame() {
        rectangles.append(rect2Posi)
    }
    
    private func Loop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            rest()
            startGame()
            Move()
            Loop()
        }
    }
    
    private func rest() {
        rectangles.removeAll()
    }
}

#Preview {
    RectTestView()
}
