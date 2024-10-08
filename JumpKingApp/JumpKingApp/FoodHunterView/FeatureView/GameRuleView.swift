//
//  BurgerKingRuleView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/03.
//

import SwiftUI

struct GameRuleView: View {
    @State private var titlePosition:CGFloat = -100
    var body: some View {
        ZStack {
            Color.backGroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Text("GAME RULE")
                    .font(.title)
                    .offset(x:titlePosition)
                VStack {
                    HStack {
                        Text("画面上から落ちてくる")
                        Text("食物")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    Text("をキャッチして")
                    HStack {
                        Text("体重")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding(5)
                            .border(Color.gray)
                        Text("を調整しましょう!")
                    }
                }
                .foregroundColor(.black)
                .padding(.horizontal,10)
                .background(Color.bodyColor)
                .cornerRadius(15)
                .rotationEffect(Angle(degrees:0),anchor: .center)
                
                HStack {
                    ForEach(0...4,id: \.self) { _ in
                        Image("bucket")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50)
                    }
                }
                
                HStack(spacing:0) {
                    Text("ア\nイ\nテ\nム\n紹\n介")
                        .padding(5)
                        .background(Color.itemColor)
                        .cornerRadius(15)
                    //item List
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image("hamburger")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                                .padding(.trailing)
                            Text("=　体重 + 2KG")
                                .font(.title3)
                        }
                        HStack {
                            Image("french")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                                .padding(.trailing)
                            Text("=　体重 + 1KG")
                                .font(.title3)
                        }
                        
                        HStack {
                            Image("vagetable")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                                .padding(.trailing)
                            Text("=　体重 - 1KG")
                                .font(.title3)
                        }
                        
                        HStack {
                            Image("poo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                            Text("=")
                                .font(.title3)
                                .padding(.horizontal)
                            Image("bkheart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:25)
                            Text("-　1")
                                .font(.title3)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.itemList)
                    .cornerRadius(15)
                }
            }
            .frame(height: UIScreen.main.bounds.height/3+50)
        }
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .onAppear() {
            titlePositionMove()
        }
    }
    private func titlePositionMove() {
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: true)) {
            titlePosition += 200
        }
    }
}

extension Color {
    static var bodyColor:Color {
        return Color(
            Color(hue: 0.5, saturation: 0.5, brightness: 0.8)
        )
    }
}
extension Color {
    static var backGroundColor:Color {
        return Color(
            Color(hue: 0.1, saturation: 0.2, brightness: 0.9)
        )
    }
}
extension Color {
    static var titleColor:Color {
        return Color(
            Color(hue: 0.1, saturation: 1.0, brightness: 1.0)
        )
    }
}

extension Color {
    static var itemColor:Color {
        return Color(
            Color(hue: 0.3, saturation: 0.5, brightness: 1.0)
        )
    }
}

extension Color {
    static var itemList:Color {
        return Color(
            Color(hue: 1.0, saturation: 0.3, brightness: 1.0)
        )
    }
}

#Preview {
    GameRuleView()
}
