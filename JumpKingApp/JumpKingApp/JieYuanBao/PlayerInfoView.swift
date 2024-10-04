//
//  PlayerInfoView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/04.
//

import SwiftUI

struct PlayerInfoView: View {
    @ObservedObject var bmidata: BmiData
    @State private var MoveToPlay:Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Section(header: Text("基本情報").foregroundColor(.white)) {
                    TextField("名前", text: $bmidata.playerName)
                        .accentColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                    
                    TextField("身長 (cm)", text: Binding(
                        get: {String(format: "%.2f", bmidata.playerHeight)},
                        set: { newValue in
                            if let height = Double(newValue) {
                                bmidata.playerHeight = height
                            }
                        }
                    ))
                    .accentColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    TextField("体重 (kg)", text: Binding(
                        get: {String(format:"%.2f", bmidata.playerWeight)},
                        set: { newValue in
                            if let weight = Double(newValue) {
                                bmidata.playerWeight = weight
                            }
                        }
                    ))
                    .accentColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                }
            }
            .frame(width:UIScreen.main.bounds.width / 2)
            
            Button(action: {
                MoveToPlay = true
            }) {
                Text("遊びに行く")
            }
            .offset(y: 150)
        }
        .fullScreenCover(isPresented: $MoveToPlay) {
            BoomView(bmidata: BmiData())
        }
//        .onAppear {
//            // 在出现时可能需要激活键盘
//            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
//            //            }
//        }
//        .onDisappear {
//            // 在消失时关闭键盘
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
    }
}

#Preview {
    PlayerInfoView(bmidata: BmiData())
}
