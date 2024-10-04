//
//  PlayerInfoView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/04.
//

import SwiftUI

struct PlayerInfoView: View {
    //    @EnvironmentObject var bmidata: BmiData
    @ObservedObject var bmidata = BmiData.shared
    @State private var MoveToPlay:Bool = false
    
    
    //
    @State private var Name: String = ""
    @State private var Height: String = ""
    @State private var Weight: String = ""
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Section(header: Text("基本情報").foregroundColor(.white)) {
                    TextField("名前", text:$Name)
                        .accentColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                    TextField("身長 (cm)", text:$Height)
                        .accentColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .keyboardType(.decimalPad)
                    TextField("体重 (kg)", text:$Weight)
                        .accentColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .keyboardType(.decimalPad)
                }
            }
            .frame(width:UIScreen.main.bounds.width / 2)
            
            Button(action: {
                bmidata.playerName = Name
                let bmi = Double(Weight)! / ((Double(Height)! / 100 ) * (Double(Height)! / 100))
                bmidata.bmi = bmi
                MoveToPlay = true
            }) {
                Text("遊びに行く")
            }
            .offset(y: 150)
        }
        .fullScreenCover(isPresented: $MoveToPlay) {
            BoomView()
        }
        .onAppear {
            // 在出现时可能需要激活键盘
            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
        }
        .onDisappear {
            // 在消失时关闭键盘
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    PlayerInfoView()
}
