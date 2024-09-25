//
//  MenuView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/09.
//

import SwiftUI

struct ItemList: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let info: String
}

let itemList = [
    ItemList(icon: "abokado", name: "アボカド", info: "Point + 100"),
    ItemList(icon: "staritem", name: "無敵", info: "障害物無視")
]

struct MenuView: View {
    var body: some View {
        ScrollView {
            //rule bar
            ZStack {
                Rectangle()
                    .fill(.red)
                    .cornerRadius(15)
                    .padding(.horizontal)
                Text("ゲームルール")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 50)
            //item bar
            ZStack {
                Rectangle()
                    .fill(.green)
                    .cornerRadius(15)
                    .padding(.horizontal)
                Text("アイテム紹介")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            VStack(spacing: 20) {
                ForEach (itemList) { item in
                    HStack {
                        Image(item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .fontWeight(.bold)
                                .font(.title2)
                            Text(item.info)
                        }
                    }
                }
            }
            .padding(.leading,30)
            .frame(width:UIScreen.main.bounds.width,alignment: .leading)
        }
    }
}

#Preview {
    MenuView()
}
