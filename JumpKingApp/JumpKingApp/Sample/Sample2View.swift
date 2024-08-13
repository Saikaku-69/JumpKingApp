//import SwiftUI
//
//struct Sample2View: View {
//    @State var Xpos: CGFloat = 200
//    @State var position: CGFloat = 500
//    @State private var rectangles1: [CGRect] = []
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    startLoop()
//                }) {
//                    Text("Start Loop")
//                }
//            }
//            
//            ForEach(rectangles1, id: \.self) { rect in
//                Rectangle()
//                    .fill(Color.random)
//                    .frame(width: rect.width, height: rect.height)
//                    .position(x: rect.origin.x, y: rect.origin.y)
//            }
//        }
//    }
//    
//    private func startLoop() {
//        DispatchQueue.global(qos: .background).async {
//            repeat {
//                DispatchQueue.main.async {
//                    rest()
//                    createRectangle()
//                    Move()
//                }
//                sleep(1) // 延迟1秒，避免主线程阻塞
//            } while true
//        }
//    }
//    
//    private func rest() {
//        // 此处可以定义rest的行为
//        Xpos = 300
//    }
//    
//    private func createRectangle() {
//        // 随机生成矩形大小
//        let randomWidth = CGFloat.random(in: 50...100)
//        let randomHeight = CGFloat.random(in: 20...50)
//        
//        let newRect = CGRect(x: Xpos, y: position, width: randomWidth, height: randomHeight)
//        rectangles1.append(newRect)
//    }
//    
//    private func Move() {
//        // 此处定义矩形移动的逻辑
//        position -= 50
//    }
//}
//
//#Preview {
//    Sample2View()
//}
