//
//  ContentView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/13.
//

import SwiftUI

//func circlesResult(_ Dog: Circle, _ rectangle: Circle) -> Bool {
//    let disX = Dog.center.x - rectangle.center.x
//    let disY = Dog.center.y - rectangle.center.y
//    let distanceTest = sqrt(disX * disX + disY * disY)
//    return distanceTest < Dog.radius + rectangle.radius
//}

struct ContentView: View {
    @State private var Xposi:CGFloat = 375
    @State private var Yposi:CGFloat = 275
    
    //定义中心点和半径
//    let Dog = Circle(center: CGPoint(x:50,y:50), radius: 50)
//    let rectangle = Circle(center: CGPoint(x:50,y:50), radius: 50)
//    
//    var result: Bool {
//        circlesResult(Dog, rectangle)
//    }
    
    var body: some View {
        //testButton
        HStack {
            Button(action: {
                Xposi = 375
            }) {
                Text("resest")
            }
            Spacer()
            Button(action: {
                withAnimation {
                    MoveX()
                }
            }) {
                Text("start")
            }
        }.frame(width:200)
        //障害物
        ZStack {
            //犬IMG
            Image("dog")
                .position(x:100,y:275)
            Rectangle()
                .fill(
                    Color(Color.red)
                )
                .frame(width:50,height: 50)
                .position(x:Xposi,y:Yposi)
        }
        .frame(width:UIScreen.main.bounds.width,height: 300)
        .border(.gray)
    }
    //Move.func
    private func MoveX() {
        Xposi -= 375
    }
}

//Rectangle.Color
//extension Color {
//    static var Color: Color {
//        return Color(
//            red: Double.random(in:0...1),
//            green: Double.random(in:0...1),
//            blue: Double.random(in:0...1)
//        )
//    }
//}

#Preview {
    ContentView()
}
