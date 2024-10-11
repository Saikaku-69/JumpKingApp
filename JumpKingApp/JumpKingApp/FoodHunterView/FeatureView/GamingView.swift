//
//  GamingView.swift
//  JumpKingApp
//
//  Created by cmStudent on 2024/10/02.
//

import SwiftUI
import UIKit

//itemの構造体を定義
struct Item: Identifiable {
    var id = UUID()
    var position: CGPoint
    var imageName: String
    
    //Itemの大きさを定義する
    static let itemWidth: CGFloat = 30
    static let itemHeight: CGFloat = 30
}


struct GamingView: View {
    //基本情報のデータを取得し、bmiDataとして定義する
    @ObservedObject var bmiData = BmiData.shared
    //falseになるとカウントダウンしてゲーム開始する
    @State private var startButton:Bool = true
    @State private var GetItem:[Item] = []
    //item生成時の高さ
    @State private var itemCreatePositionY:CGFloat = 25
    //スクリーンの高さとItemが消えるのを判定するラインを初期化する
    @State private var screenHeight: CGFloat = 0
    @State private var deadLine: CGFloat = 0
    //itemが落下するAnimationために使うタイマー
    @State private var downTimer: Timer?
    //このViewで使う体重を初期化する
    @State private var realTimeWeight:Double = 0.0
    //mainObjectの大きさを定義する
    @State private var mainObFrame:CGFloat = 50
    //mainObjectのポジションXとYを定義する
    @State private var mainObPositionX: CGSize = .zero
    @State private var mainObPostionY: CGFloat = UIScreen.main.bounds.height - 120
    //移動のために使う偏差値をzeroで初期化する
    @GestureState private var dragObPositionX: CGSize = .zero
    //生命数を初期化する
    @State private var totalLife:Int = 1
    //Lifeの値を初期化する
    @State private var lifeCount:Int = 1
    //trueになるとItem生成開始
    @State private var gameStarted:Bool = false
    //ゲーム時間をカウントするタイマー&ゲーム時間を60秒に初期化
    @State private var gameTimer: Timer?
    @State private var gameTimeCount: Double = 60
    //trueになるとアラートでゲーム結果を出す
    @State private var gameOverResult:Bool = false
    //ゲーム終了後のBMI計算ために初期化
    @State private var newBMI: Double = 0.0
    //mainObject移動の禁止
    @State private var gestureStop:Bool = true
    //基本情報入力画面に遷移用ボタンのFlag
    @State private var resetButton:Bool = true
    //基本情報入力画面に遷移用のFlag
    @State private var moveToInfoView:Bool = false
    //計算したBMIをString型のキャスト
    @State private var bmiResultMessage = ""
    //カウントダウン用の配列を定義する
    let countDownArray = ["3","2","1"]
    //配列をカウントするために0として初期化
    @State private var countDownIndex = 0
    //
    @State private var createTimer: Timer?
    //
    @State private var countDownButton:Bool = true
    var body: some View {
        ZStack {
            //GeometryReader 可以获取父视图的尺寸信息，可以根据可用空间动态调整图片的大小，使其适应不同尺寸的设备。
//            GeometryReader { geometry in
//                Image("bkbg1")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//                    .edgesIgnoringSafeArea(.all)
//            }
            //カウントダウンを表示用のFlag
            if startButton {
                Text(countDownArray[countDownIndex])
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            //mainObject用のイメージ
            ZStack {
                Image("ManChar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: mainObFrame + 30)
                    .position(x: mainObPositionX.width + dragObPositionX.width + 15,y: mainObPostionY + 20)
                Image("bucket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: mainObFrame)
                    .position(x: mainObPositionX.width + dragObPositionX.width,y: mainObPostionY)
                    .opacity(0)
            }
            //mainObjectとdragして移動する
            .gesture(
                DragGesture()
                    .updating($dragObPositionX) { move, value, _ in
                        value = move.translation
                        collision()
                    }
                    .onEnded { value in
                        mainObPositionX.width += value.translation.width
                        collision()
                    }
            )
            //決めた条件のみ移動可能にする
            .disabled(gestureStop)
            //GetIemにあるItemをForEachで出す
            ForEach(GetItem) { item in
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:Item.itemWidth,height:Item.itemHeight)
                    .position(item.position)
            }
            HStack {
                //ゲーム時間をゲージで表す
                Gauge(value: gameTimeCount, in: 0...60) {
                    Text("\(Int(gameTimeCount))")
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(Color.blue)
                //体重&BMI&生命数をVStackで並んで、表示する場所を定義
                VStack {
                    //体重を表すテキスト
                    HStack {
                        Text("あなたの体重:")
                        Text("\(Int(realTimeWeight))")
                            .foregroundColor(.red)
                        Text("KG")
                    }
                    //BMIを表すテキスト
                    HStack {
                        Text("BMI:")
                        Text("\(newBMI, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                    //生命数を表示
                    HStack {
                        ForEach(0..<lifeCount,id: \.self) { _ in
                            Image("bkheart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20)
                        }
                        ForEach(lifeCount..<1,id: \.self) { _ in
                            Image("bkheartblack")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20)
                        }
                    }
                }
                .fontWeight(.bold)
                Button(action: {
                    stopGame()
                }) {
                    Text("棄権")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .disabled(countDownButton)
            }
            .offset(y: -330)
        }
        //設備の大きさにより変化
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        //設備の全画面を使用
        .edgesIgnoringSafeArea(.all)
        //この画面を開いた時に行う処理
        .onAppear() {
            //画面の高さを変数に代入する
            screenHeight = UIScreen.main.bounds.height
            //消える判定ラインを画面の高さにする
            deadLine = screenHeight
            //入力した体重の値をrealTimeWeight変数に代入
            realTimeWeight = bmiData.weight
            //mainObjectのポジションを真ん中に初期化
            mainObPositionX.width = UIScreen.main.bounds.width/2
            //入力したデータで計算BMIを計算する
            calculateBMI()
            //ゲームが始めるための準備
            startGame()
            //カウントダウン開始
            startCountDown()
        }
        //画面が消える時に行う処理
        .onDisappear {
            //全てのタイマーを停止
            createTimer?.invalidate()
            downTimer?.invalidate()
            gameTimer?.invalidate()
        }
        //ゲーム終了したら行う処理
        .alert(isPresented: $gameOverResult) {
            Alert(title: Text("ゲーム終了"),
                  message: Text("なし"),
                  primaryButton: .default(Text("もう一度")) {
                initialGame()
            },
                  secondaryButton: .default(Text("もっとみる")) {
            })
        }
        .fullScreenCover(isPresented: $moveToInfoView) {
            PlayerInfoView()
        }
    }
    private func stopGame() {
        createTimer?.invalidate()
        downTimer?.invalidate()
        gameTimer?.invalidate()
        GetItem.removeAll()
        gameTimeCount = 60
        countDownIndex = 0
        lifeCount = 1
        mainObPositionX.width = UIScreen.main.bounds.width/2
        moveToInfoView = true
    }
    private func initialGame() {
        //リットするデータ
        gameTimeCount = 60
        countDownIndex = 0
        startButton = true
        startCountDown()
        startGame()
        lifeCount = 1
        mainObPositionX.width = UIScreen.main.bounds.width/2
    }
    //BMI公式
    private func calculateBMI() {
        newBMI = Double(realTimeWeight) / ((bmiData.height / 100 ) * (bmiData.height / 100))
    }
    //ゲーム開始を処理
    private func startGame() {
        //まずは(情報)リセットボタンを隠す
        resetButton = false
        //mainObject移動できるようにする
        gestureStop = false
        //trueになったらItem生成する
        gameStarted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            //3秒後にカウントダウンTextを隠す
            startButton = false
            gaming()
            gameTime()
        }
    }
    //itemで生成する画像をランダムで代入、ポジションXの範囲を定義
    //GetItem構造体を使ったnewItemとして生成する
    private func createItem() {
        let images = ["hamburger", "poo", "vagetable","french"]
        let randomImage = images.randomElement() ?? "hamburger"
        let randomX = CGFloat.random(in: 25...(UIScreen.main.bounds.width - Item.itemWidth/2))
        
        let newItem = Item(position:CGPoint(x:randomX,y:itemCreatePositionY), imageName: randomImage)
        GetItem.append(newItem)
//        print("append \(randomImage)")
    }
    //for文でIndexをカウントする
    private func startCountDown() {
        for i in 0..<countDownArray.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                countDownIndex = i
            }
        }
    }
    //itemの落下&削除のロジック
    private func fallingLogic() {
        for index in GetItem.indices.reversed() {
            if GetItem[index].position.y < deadLine {
                //Item落下する処理
                withAnimation(.linear) {
                    GetItem[index].position.y += 1
                }
            } else {
                //配列中に入ったitemを削除
                GetItem.remove(at: index)
            }
        }
    }
    //落下&削除ロジックを使用
    private func startFalling() {
        //始める前に停止
        downTimer?.invalidate()
        //0.005秒ごとにLogicを更新&当たる判定を確認する
        downTimer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { _ in
            fallingLogic()
            collision()
            gameOver()
        }
    }
    //ゲーム開始したらitemの生成&落下を行う
    private func gaming() {
        //gameStartedがtrueになった場合
        if gameStarted {
            countDownButton = false
            //0.５秒で[itemの生成&落下]を実行
            createTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                createItem()
                startFalling()
            }
        }
    }
    //itemとmainObjectのぶつかる判定
    private func collision() {
        //mainObjectのPositionとFrameを定義する
        let newMainObjectPosition = CGPoint(x: mainObPositionX.width + dragObPositionX.width, y: mainObPostionY)
        let newMainObjectFrame = CGRect( x:newMainObjectPosition.x - 30,
                                         y:newMainObjectPosition.y,
                                         width: mainObFrame,
                                         height: 1)
        //反向顺序遍历 GetItem 数组中的所有索引
        for index in GetItem.indices.reversed() {
            //itemの形を定義する
            let itemRect = CGRect(x: GetItem[index].position.x - Item.itemWidth / 2,
                                  y: GetItem[index].position.y - Item.itemHeight / 2,
                                  width:Item.itemWidth,
                                  height:Item.itemHeight)
            //判定
            if newMainObjectFrame.intersects(itemRect) {
                let itemName = GetItem[index]
                if itemName.imageName == "hamburger" {
                    //振動
                    generateImpactFeedback(for: .light)
                    //当たったら削除
                    GetItem.remove(at: index)
                } else if itemName.imageName == "vagetable" {
                    generateErrorFeedback()
                    GetItem.remove(at: index)
                } else if itemName.imageName == "french" {
                    generateImpactFeedback(for: .light)
                    GetItem.remove(at: index)
                } else {
                    generateImpactFeedback(for: .heavy)
                    GetItem.remove(at: index)
                    lifeCount -= 1
                }
//                print("collision")
            }
        }
    }
    //ゲーム終了時行う動作
    private func gameOver() {
        if gameTimeCount <= 0 || lifeCount <= 0 {
            //タイマーを止める
            createTimer?.invalidate()
            gameTimer?.invalidate()
            downTimer?.invalidate()
            countDownButton = true
            //アラートを出す
            gameOverResult = true
            //ゲームロジックを止める
            gameStarted = false
            //画面上のアイテムを削除
            GetItem.removeAll()
        }
    }
    //ゲーム時間をカウントする
    private func gameTime() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            gameTimeCount -= 1
            gameOver()
        }
    }
    //BMI公式によって健康状態を表す
    private func bmiResult() -> String {
        if newBMI >= 40 {
           return "肥満(3度)"
        } else if newBMI >= 35 {
            return "肥満(2度)"
        } else if newBMI >= 30 {
            return "肥満(1度)"
        } else if newBMI >= 25 {
            return "前肥満"
        } else if newBMI >= 18.5 {
            return "普通体重"
        } else if newBMI >= 17 {
            return "痩せぎみ"
        } else if newBMI >= 16 {
            return "痩せ"
        } else {
            return "痩せすぎ"
        }
    }
    //振動処理
    func generateImpactFeedback(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    //振動処理
    func generateErrorFeedback() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        // 类型有 .success .error 和 .warning
        //分别对应通知,错误和警告
        feedbackGenerator.notificationOccurred(.error)
    }
}
//カスタマカラー
extension Color {
    static var randomColor:Color {
        return Color(
            Color(hue: 0.6, saturation: 0.8, brightness: 0.6)
        )
    }
}

#Preview {
    GamingView()
}
