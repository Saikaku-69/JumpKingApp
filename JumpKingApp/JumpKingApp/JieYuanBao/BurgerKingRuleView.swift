//
//  BurgerKingRuleView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/03.
//

import SwiftUI

struct BurgerKingRuleView: View {
    var body: some View {
        VStack {
            Text("BurgerKingのルール")
                .font(.title)
                .padding()
                .background(Color.titleColor)
                .cornerRadius(20)
                .rotationEffect(Angle(degrees:5),anchor: .center)
                .offset(y:-10)
            Text("・画面上から落ちてくるアイテムをキャッチして\nスコアを獲得しましょう!")
                .foregroundColor(.black)
                .padding()
                .background(Color.bodyColor)
                .cornerRadius(15)
                .rotationEffect(Angle(degrees:-5),anchor: .center)
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
            HStack {
                Image("hamburger")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:30)
                    .padding(.trailing)
                Text("=　体重 + 1KG")
                    .font(.title3)
            }
            .frame(width:UIScreen.main.bounds.width - 50,alignment: .leading)
            //        .border(.gray)
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
            .frame(width:UIScreen.main.bounds.width - 50,alignment: .leading)
        }
        .fontWeight(.bold)
//        .border(.gray)
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

#Preview {
    BurgerKingRuleView()
}
