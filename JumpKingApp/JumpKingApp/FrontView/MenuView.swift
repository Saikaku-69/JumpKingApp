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
}

let itemList = [
    ItemList(icon: "abokado", name: "アボカド"),
    ItemList(icon: "staritem", name: "無敵")
]

struct MenuView: View {
    var body: some View {
       //
        VStack(alignment: .leading) {
            ForEach (itemList) { item in
                HStack {
                    Image(item.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:50)
                    Text(item.name)
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
