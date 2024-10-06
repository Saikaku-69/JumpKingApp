//
//  BurgerKingRuleView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/03.
//

import SwiftUI

struct BurgerKingRuleView: View {
    @State private var titlePosition:CGFloat = -50
    var body: some View {
        ZStack {
            Color.backGroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Text("RULE")
                    .font(.title)
//                    .padding(10)
//                    .background(Color.titleColor)
//                    .cornerRadius(20)
//                    .rotationEffect(Angle(degrees:2),anchor: .center)
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
                .padding()
                .background(Color.bodyColor)
                .cornerRadius(15)
//                .rotationEffect(Angle(degrees:-5),anchor: .center)
                HStack {
                    Spacer()
                    Text("↓ アイテム紹介 ↓")
                        .padding()
                        .background(Color.itemColor)
                        .cornerRadius(15)
                    Spacer()
                }
                .padding(.vertical)
                //item List
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image("hamburger")
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
                            .frame(width:30)
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
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .onAppear() {
//            titlePositionMove()
        }
    }
    private func titlePositionMove() {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
            titlePosition += 100
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
            Color(hue: 0.1, saturation: 0.3, brightness: 0.9)
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
    BurgerKingRuleView()
}
