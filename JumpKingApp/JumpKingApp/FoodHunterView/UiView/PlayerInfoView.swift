//
//  PlayerInfoView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/04.
//

import SwiftUI

struct PlayerInfoView: View {
    
    @ObservedObject var bmidata = BmiData.shared
    @State private var MoveToPlay:Bool = false
    
    @State private var Name: String = ""
    @State private var Height: String = ""
    @State private var Weight: String = ""
    
    // FocusState 管理焦点
    @FocusState private var focusedField: Field?
    enum Field {
            case name, height, weight
        }
    
    var body: some View {
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    HStack {
                        Text("F")
                            .rotationEffect(Angle(degrees: -30), anchor: .trailing)
                        ZStack {
                            Text("O")
                            Image("hamburger")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:25)
                        }
                        ZStack {
                            Text("O")
                            Image("french")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                        }
                        Text("D")
                            .rotationEffect(Angle(degrees: 25), anchor: .leading)
                    }
                    .font(.system(size:50))
                    Text(" HUNTER")
                        .font(.system(size:30))
                }
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(height:UIScreen.main.bounds.height/(6/1))
//                .offset(y:2/UIScreen.main.bounds.height)
//                .border(.red)
                
                VStack {
                    Section(header: Text("基本情報")
                        .foregroundColor(.white)
                        .fontWeight(.bold)) {
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
                    
                    Button(action: {
                        Height = String(Int.random(in: 150...180))
                        Weight = String(Int.random(in: 50...80))
                    }) {
                        Text("ランダム")
                    }
                    .padding(.top)
                    
                    Button(action: {
                        bmidata.playerName = Name
                        let bmi = Double(Weight)! / ((Double(Height)! / 100 ) * (Double(Height)! / 100))
                        bmidata.bmi = bmi
                        bmidata.weight = Double(Weight) ?? 0.0
                        bmidata.height = Double(Height) ?? 0.0
                        MoveToPlay = true
                    }) {
                        Text("遊びに行く")
                    }
                    .padding(.top)
                    .disabled(Height.isEmpty || Weight.isEmpty)
                    
                }
                .frame(width:UIScreen.main.bounds.width / 2,height:UIScreen.main.bounds.height/3)
//                .border(.red)
//                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $MoveToPlay) {
            GamingView()
        }
    }
}

#Preview {
    PlayerInfoView()
}
