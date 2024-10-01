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
    //分数
    @State private var Score:Int = 0
    
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
    
    @State private var mainObjectPositionY: CGFloat = 300
    @State private var HomePage:Bool = false
    
    //mainObject New Position
    @State private var objectPositionX:CGSize = .zero
    @State private var objectPositionY:CGFloat = 700
    
    @GestureState private var NewobjectPositionX:CGSize = .zero
    @GestureState private var NewobjectPositionY:CGFloat = 700
    
    
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
//            Rectangle()
//                .fill(.green)
//                .frame(width:100,height:50)
//                .offset(x:MainRectPosition.width + DragRectPosition.width,y: mainObjectPositionY)
//                .gesture(
//                    DragGesture()
//                        .updating($DragRectPosition) {value, item,_ in
//                            item = value.translation
////                            collision()
//                        }
//                        .onEnded { value in
//                            MainRectPosition.width += value.translation.width
////                            collision()
//                        }
//                )
            Rectangle()
                .fill(.green)
                .frame(width:100,height:50)
                .position(x:objectPositionX.width + NewobjectPositionX.width,y:objectPositionY)
                .gesture(
                    DragGesture()
                        .updating($NewobjectPositionX) {value, item,_ in
                            item = value.translation
                            collision()
                        }
                        .onEnded { value in
                            objectPositionX.width += value.translation.width
                            collision()
                        }
                )
            
            //得分情况
            Button(action: {
                HomePage = true
            }) {
                Text("スコア：\(Score)")
            }
            .offset(y: -300)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .border(.gray)
        .fullScreenCover(isPresented: $HomePage) {
            FrontView()
        }
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
            collision()
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
    
    private func collision() {
        // 计算主物体的实际位置
        let actualPosition = CGPoint(x:objectPositionX.width + NewobjectPositionX.width, y: objectPositionY)
        let mainObjectFrame = CGRect(x: actualPosition.x - 50, y: actualPosition.y, width: 100, height: 50)

        for index in GetYuanBao.indices.reversed() {
            let yuanbaoFrame = CGRect(x: GetYuanBao[index].position.x - YuanBaoWidth / 2,
                                      y: GetYuanBao[index].position.y - YuanBaoHeight / 2,
                                      width: YuanBaoWidth,
                                      height: YuanBaoHeight)
            
            if mainObjectFrame.intersects(yuanbaoFrame) {
                // 如果发生碰撞，处理元宝的消失
                GetYuanBao.remove(at: index)
                Score += 100
            }
        }
    }
}

#Preview {
    JieYuanBaoView()
}
