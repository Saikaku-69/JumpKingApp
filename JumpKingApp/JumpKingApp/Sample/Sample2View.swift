import SwiftUI

struct jumpTestView: View {
    @State private var rect1Posi:CGPoint = CGPoint(x:100,y:280)
    @State private var rect2Posi:CGPoint = CGPoint(x:300,y:280)
    
    //    @State private var Xposi:CGFloat = 300
    @State private var Xposi:CGFloat = 150
    
    @State private var Yposi:CGFloat = 280
    
    @State private var showAlert = false
    @State private var timer: Timer?
    
    @State private var onTap = false
    
    var body: some View {
        HStack {
            Button(action: {
                Move()
            }) {
                Text("test")
            }
            .padding(.trailing,50)
            Button(action: {
                rect2Posi = CGPoint(x: 300, y: 280)
            }) {
                Text("reset")
            }
        }
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width:50,height: 50)
                .position(x:100, y: Yposi)
            Rectangle()
                .fill(.red)
                .frame(width:50,height: 50)
                .position(x:Xposi,y:280)
                .onChange(of: rect2Posi.x) {
                    checkMove()
                }
        }
        .frame(width:UIScreen.main.bounds.width,height: 305)
        .border(.gray)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over"),
                  message: Text(""),
                  dismissButton: .default(Text("OK")))
        }
        Button(action: {
            jump()
        }) {
            Text("jump")
        }
        .padding(.top,100)
    }
    
    private func Move() {
        withAnimation(.linear(duration: 3.0)) {
            rect2Posi.x -= 300
        }
        moveTimer()
    }
    private func checkMove() {
        let rect1Frame = CGRect(x:rect1Posi.x, y: rect1Posi.y, width:50,height:50)
        let rect2Frame = CGRect(x:rect2Posi.x, y: rect2Posi.y, width:50,height:50)
        if rect1Frame.intersects(rect2Frame) {
            showAlert = true
            timer?.invalidate()
        }
    }
    private func moveTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            checkMove()
        }
    }
    
    private func newResult() {
        if Xposi <= 150 && Yposi >= 200 {
            
        }
    }
    private func jump() {
        onTap = true
        withAnimation {
            Yposi -= 80
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    Yposi += 80
                }
            }
        }
    }
}

#Preview {
    jumpTestView()
}
