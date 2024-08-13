//
//  RectangleCreateView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/08/13.
//

import SwiftUI
//
//struct RectangleCreateView: View {
//    @State var position:CGFloat = 500
//    var body: some View {
//        HStack {
//            Button(action: {
//                position = 500
//                withAnimation {
//                    testMove()
//                }
//                //自动生成
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    createRectangle()
//                    testMove()
//                }
//            }) {
//                Text("Reset")
//            }
//        }
//        Rectangle()
//            .frame(width:50,height:20)
//            .position(x:200,y:position)
//            .onAppear {
//                withAnimation {
//                    testMove()
//                }
//            }
//    }
//    
//    private func testMove() {
//        position -= 500
//    }
//    private func createRectangle() {
//        while true {
//            Rectangle()
//                .fill(Color.red)
//                .frame(width:50,height:20)
//                .position(x:200,y:position)
//        }
//    }
//}

struct RectangleCreateView: View {
    @State private var position: CGFloat = 500
    @State private var rectangles: [CGFloat] = [] // 用于存储每个 Rectangle 的位置
    
    var body: some View {
        VStack {
                Button(action: {
                    resetPosition()
                }) {
                    Text("Reset")
                }
            
            // 初始的 Rectangle
            Rectangle()
                .frame(width: 50, height: 20)
                .position(x: 200, y: position)
                .onAppear {
                    withAnimation {
                        testMove()
                    }
                }
            
            // 动态生成的 Rectangles
            ForEach(rectangles, id: \.self) { yPos in
                Rectangle()
//                    .fill(Color.random)
                    .frame(width: 50, height: 20)
                    .position(x: 200, y: yPos)
            }
        }
    }
    
    private func resetPosition() {
        position = 500
        rectangles.removeAll() // 清空已生成的 Rectangles
        withAnimation {
            testMove()
        }
        // 自动生成新的 Rectangle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            createRectangle()
            testMove()
        }
    }
    
    private func testMove() {
        position -= 500
    }
    
    private func createRectangle() {
        let newPosition = position // 获取当前的 position
        rectangles.append(newPosition) // 将新位置添加到 rectangles 列表中
    }
}

//extension Color {
//    static var random: Color {
//        return Color(
//            red: Double.random(in: 0...1),
//            green: Double.random(in: 0...1),
//            blue: Double.random(in: 0...1)
//        )
//    }
//}

#Preview {
    RectangleCreateView()
}
