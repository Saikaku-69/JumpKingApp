//
//  Sample3View.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/13.
//

import SwiftUI

struct Sample3View: View {
    
    @State private var Xpos:CGFloat = 600
    @State private var rectangles: [CGFloat] = []
    @State private var Ypos:CGFloat = 475
    @State private var isWait:Bool = false
    @State private var isPaused: Bool = false
    @State private var timer: Timer?
    @State private var isPresented: Bool = false
    
    var body: some View {
        
        Button(action: {
            isPaused.toggle()
            isPresented = true
        }) {
            Rectangle()
                .fill(isPaused ? .green : .red)
                .frame(width:50,height:25)
        }
        .padding()
        
        HStack {
            ZStack {
                
                Image("dog")
                    .position(x:120,y:Ypos)
                
                ForEach(rectangles,id: \.self) { newPos in
                    Rectangle()
                        .fill(Color.random)
                        .frame(width:50,height:50)
                        .position(x:Xpos,y:475)
                }
            }
        }
        .frame(width:UIScreen.main.bounds.width,height: 500)
        .border(.gray)
        .onAppear() {
            Move()
            startLoop()
        }
        Button(action: {
            jump()
            isWait = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isWait = false
            }
        }) {
            ZStack {
                Circle()
                    .fill(.gray)
                    .opacity(0.8)
                Text("Jump")
                    .foregroundColor(.black)
            }
            .frame(width:50)
            .padding()
        }.disabled(isWait)
    }
    
    private func rest() {
        rectangles.removeAll()
        Xpos = 600
    }
    
    private func Move() {
        withAnimation(.linear(duration: 2.0)) {
            Xpos -= 800
        }
    }
    
    private func createRectangle() {
        rectangles.append(Xpos)
    }
    
    private func startLoop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            rest()
            createRectangle()
            Move()
            startLoop()
        }
    }
    
    private func jump() {
        withAnimation(
            Animation.linear(duration: 0.3)
                .repeatCount(1, autoreverses: true)
        ) {
            Ypos -= 80
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.6)) {
                Ypos += 80
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

#Preview {
    Sample3View()
}
