//
//  NewModeView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/24.
//

import SwiftUI

struct NewModeView: View {
    //進行中の位置
    @State private var position:CGPoint = CGPoint(x:50,y:50)
    @State private var defaultPosition:CGPoint = CGPoint(x:50,y:430)
    @State private var Gaming:Bool = false
    @State private var RotationAngle: Double = 0
    @State private var timer:Timer? = nil
    
    var body: some View {
        Button(action: {
            up()
        }) {
            Image("start")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:150)
        }
        
//        HStack {
//            Spacer()
//            Button(action: {
//                fallDown()
//            }) {
//                Circle()
//                    .fill(.red)
//                    .frame(width:30)
//            }
//        }
        VStack {
            //            Image("sword")
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .frame(width:100)
            //                .rotationEffect(Angle(degrees: -45), anchor: .bottom)
            if Gaming {
                Image("roket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
                    .rotationEffect(Angle.degrees(RotationAngle), anchor: .center)
                    .position(position)
            } else {
                Image("roket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
                    .rotationEffect(Angle.degrees(0), anchor:.bottom)
                    .position(defaultPosition)
            }
            Spacer()
            ZStack {
                Rectangle()
                    .fill(.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height:25)
                Text("地面: height:25")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .border(.black)
        
        Button(action: {
            flyUp()
        }) {
            Image("jumpButton")
        }
    }
    
    private func flyUp() {
        withAnimation(.easeInOut(duration:0.3)) {
            RotationAngle -= 45
            position.y -= 40
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                RotationAngle += 45
            }
        }
        position.y -= 1
    }
    private func up() {
        withAnimation(.easeInOut(duration:2)) {
            defaultPosition.y -= 380
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            Gaming = true
            withAnimation(.linear(duration:1)) {
                RotationAngle += 135
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            fallDown()
        }
    }
    
    private func fallDown() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.linear(duration:0.05)) {
                if position.y <= 330 {
                    withAnimation {
                        position.y += 10
                    }
                }
            }
        }
    }
}

#Preview {
    NewModeView()
}
