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
        ZStack {
            Rectangle()
                .fill(.green)
                .frame(width:70,height:70)
                .cornerRadius(15)
            Text("Item")
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

#Preview {
    MenuView()
}
