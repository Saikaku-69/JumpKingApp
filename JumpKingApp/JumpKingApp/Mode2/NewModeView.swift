//
//  NewModeView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/24.
//

import SwiftUI

struct NewModeView: View {
    @ObservedObject private var backHomeHageButton = BackHomePageButton()
    //進行中の位置
    @State private var defaultPosition:CGPoint = CGPoint(x:50,y:585)
    @State private var Gaming:Bool = false
    @State private var RotationAngle: Double = 0
    @State private var timer:Timer? = nil
    @State private var StartButton:Bool = true
    @State private var backgroundTopPosition:CGPoint = CGPoint(x:200,y:20)
    @State private var disableScreen:Bool = true
    
    var body: some View {
        ZStack {
            Button(action: {
                flyUp()
            }) {
                Rectangle()
                    .opacity(0.0)
            }
            .disabled(disableScreen)
            .border(.gray)
            VStack {
                Button(action: {
                    backHomeHageButton.backHomePage = true
                }) {
                    Image("sword")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:100)
                        .rotationEffect(Angle(degrees: -45), anchor: .bottom)
                }
                Image("roket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
                    .rotationEffect(Angle.degrees(RotationAngle), anchor:.center)
                    .position(defaultPosition)
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity)
                        .frame(height:25)
                    Text("地面: height:25")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .border(.black)
            if StartButton {
                Button(action: {
                    up()
                    StartButton = false
                    disableScreen = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        disableScreen = false
                    }
                }) {
                    Image("start")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:150)
                }
            }
        }
        .fullScreenCover(isPresented: $backHomeHageButton.backHomePage) {
            FrontView()
        }
    }
    
    private func flyUp() {
        withAnimation(.easeInOut(duration:0.3)) {
            RotationAngle -= 45
            //如果要添加碰撞判定就要细分化Position
            defaultPosition.y -= 70
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                RotationAngle += 45
            }
        }
        defaultPosition.y -= 1
    }
    private func up() {
        withAnimation(.easeInOut(duration:2)) {
            defaultPosition.y -= 380
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.linear(duration:1)) {
                RotationAngle += 135
            }
        }
        //落ちる計算
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            fallDown()
        }
    }
    
    private func fallDown() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.linear(duration:0.05)) {
                if defaultPosition.y <= 585 {
                    withAnimation {
                        defaultPosition.y += 15
                    }
                }
            }
        }
    }
}

#Preview {
    NewModeView()
}
