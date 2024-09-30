//
//  JieYuanBaoView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/09/29.
//

import SwiftUI
// 元宝位置结构体
struct YuanBao: Identifiable {
    var id = UUID()
    var position: CGPoint
}

struct JieYuanBaoView: View {
    @State private var StartButton:Bool = true
    //元宝大小
    @State private var YuanBaoWidth:CGFloat = 50
    @State private var YuanBaoHeight:CGFloat = 50
    
    //生成元宝数组
    @State private var GetYuanBao: [YuanBao] = []
    
    //计算屏幕高度，来设置deadline (碰撞后元宝消失)
    @State private var screenHeight: CGFloat = 0
    @State private var maxY: CGFloat = 0
    
    //定时器为了实时观察判定
    @State private var FallTimer: Timer?
    
    //计算偏差值，并实时更新主物体的最新位置
    @State private var MainRectPosition:CGSize = .zero
    @GestureState private var DragRectPosition:CGSize = .zero
    
    var body: some View {
        
        ZStack {
            //生成元宝放入数组中
            //暂用Rectangle来代替元宝Img
            ForEach(GetYuanBao) { item in
                Rectangle()
                    .fill(.yellow)
                    .frame(width:YuanBaoWidth,height:YuanBaoHeight)
                    .position(item.position)
            }
            //主物体，碰撞就判定加分
            
            //设置判定线，触碰就会消失
            
            //游戏开始按键 = 生成元宝
            if StartButton {
                Button(action: {
                    gaming()
                    StartButton = false
                }) {
                    Text("Game Start")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(.black)
                        .cornerRadius(10)
                }
            }
            //控制主物体水平移动
            Rectangle()
                .fill(.green)
                .frame(width:100,height:50)
                .offset(x:MainRectPosition.width + DragRectPosition.width,y: 300)
                .gesture(
                    DragGesture()
                        .updating($DragRectPosition) {value, item,_ in
                            item = value.translation
                        }
                        .onEnded { value in
                            MainRectPosition.width += value.translation.width
                        }
                )
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .border(.gray)
        .onAppear() {
            // 计算屏幕高度和最大 Y 值
            screenHeight = UIScreen.main.bounds.height
            maxY = screenHeight - 50 // 设置 deadline (碰撞后元宝消失)
        }
        .onDisappear {
            // 停止定时器
            FallTimer?.invalidate()
        }
        
        
        
    }
    
    private func creatYuanBao() {
        //生成元宝时，定义X轴上的范围
        let RandomX = CGFloat.random(in: 25...(UIScreen.main.bounds.width - YuanBaoWidth / 2))
        let newYuanBao = YuanBao(position: CGPoint(x: RandomX, y: 25))
        GetYuanBao.append(newYuanBao)
    }
    
    private func startFalling() {
        FallTimer?.invalidate() // 确保之前的定时器停止
        FallTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            fallOut()
        }
    }
    //坠落效果
    private func fallOut() {
        for index in GetYuanBao.indices.reversed() {
            if GetYuanBao[index].position.y < maxY {
                withAnimation(.linear) {
                    GetYuanBao[index].position.y += 10
                }
            } else {
                GetYuanBao.remove(at: index)
            }
        }
    }
    
    private func gaming() {
        creatYuanBao()
        startFalling()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            gaming()
        }
    }
    
//    private func collision() {
//        let mainObjectFrame = CGRect(x: MainRectPosition.width + DragRectPosition.width, y: 300, width: 100, height: 50)
//        for yuanbao in GetYuanBao {
//            let yuanbaoFrame = CGRect(x: yuanbao.position.x - YuanBaoWidth / 2, y: yuanbao.position.y - YuanBaoHeight / 2, width: YuanBaoWidth, height: YuanBaoHeight)
//        }
//    }
}

#Preview {
    JieYuanBaoView()
}
