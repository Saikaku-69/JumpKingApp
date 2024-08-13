//
//  mapView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/13.
//

import SwiftUI

struct SampleView: View {
    @State var playerPosition:CGPoint = CGPoint(x: 150, y: 265)
    @State var mapPosition:CGPoint = CGPoint(x: 200, y: 140)
    @State var newPosition:CGPoint = CGPoint(x: 300, y: 140)
    
    @State private var showNewRectangle: Bool = true
    @State private var isStart: Bool = true
    
    var body: some View {
        Button(action: {
            playerPosition = CGPoint(x: 150, y: 265)
            mapPosition = CGPoint(x: 200, y: 140)
            newPosition = CGPoint(x: 300, y: 140)
            isStart = true
        }) {
            Text("Reset")
        }
        VStack {
            Image("dog")
                .position(playerPosition)
            HStack {
                Rectangle()
                    .frame(width: 200,height: 10)
                    .position(mapPosition)
                
                if showNewRectangle {
                    Rectangle()
                        .frame(width:200,height:10)
                        .position(newPosition)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width,height: 300)
        .border(.gray)
        
        VStack {
            Button(action: {
                isStart = false
                mapMove()
            }) {
                if isStart {
                    Text("開始")
                        .padding()
                }
            }
            Spacer()
            Button(action: {
                jump()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.8)
                        .aspectRatio(contentMode: .fit)
                    Text("JUMP")
                        .foregroundColor(.black)
                }
            }
            .frame(width:60)
        }
        .frame(height:200)
    }
    private func mapMove() {
        withAnimation(.linear(duration: 0.5)) {
            mapPosition.x -= 300
            showNewRectangle = true
            
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {
                withAnimation(.linear(duration: 1.0)) {
                    newPosition.x -= 610
                }
            }
        }
    }
    private func jump() {
        withAnimation(.easeInOut(duration: 0.5)) {
            playerPosition.y -= 50
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    playerPosition.y += 50
                }
            }
        }
    }
}

#Preview {
    SampleView()
}
