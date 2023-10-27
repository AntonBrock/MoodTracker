//
//  BreathViewComponent.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.08.2023.
//

import SwiftUI
import CoreHaptics
import Combine
import BottomSheet
import AVFoundation

class SoundPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var soundName: String = ""

    func playSound() {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Ошибка при воспроизведении звука: \(error.localizedDescription)")
            }
        }
    }
}

class TimerManagerForProgress: ObservableObject {
    @Published var counter = 3 // 5, 4, 3
    private var timerSubscription: Cancellable?

    func startTimer() {
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.counter -= 1
            }
    }

    func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
        counter = 3 // 5, 4, 3
    }
}

class TimerManagerForRemaining: ObservableObject {
    @Published var counter = 20 // 58, 77, 96 - максмальное(для отправки на бэк) (19 = (4 + 7 + 8) * 3,4,5 - подходы)
    var timerSubscription: Cancellable?
    
    var isPaused: Bool = false

    func startTimer() {
        if timerSubscription == nil {
            timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    if !self.isPaused {
                        if self.counter > 0 {
                            self.counter -= 1
                        } else {
                            self.counter = 20
                        }
                    }
                }
        }
    }
    func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
}

class TimerManager: ObservableObject { // Для старта
    @Published var counter = 5
    private var timerSubscription: Cancellable?

    func startTimer() {
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.counter -= 1
            }
    }

    func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
        counter = 5
    }
}

enum HapticPattern {
    case continuous(duration: TimeInterval, intensity: Float, sharpness: Float)
    case rampUp(duration: TimeInterval, intensity: Float, sharpness: Float)
    case rampDown(duration: TimeInterval, intensity: Float, sharpness: Float)
}

enum BreathViewComponentThemes {
    case none
    case birds
    case ocean
    case nightInForest
    case rain
}

// 4 - 7 - 8 Практика
struct BreathViewComponent: View {
    
    @Environment(\.dismiss) var dismiss
    
    var dismissAction: ((_ isMinimumProgress: Bool) -> Void)

    @Binding var progressForPractice: Int // = 3 // 3, 4, 5 - выбирает юзер
    @Binding var currentTheme: BreathViewComponentThemes // = .none

    @ObservedObject var soundPlayer = SoundPlayer()

    @State private var isSheetCountStatePresent = false
    @State private var isSheetThemesesPresent = false
    
    @State private var isSheetFinishPresent = false
    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop

    enum Mode {
        case proccess
        case beforeStart
        case end
        case pause
    }
    
    @State private var breathIn = false
    @State private var breathOut = false
    @State private var hold = false
    
    let snow = Color(.white)
    let screenBackground = Color(.black)
    
    @State private var drawingStroke = false
    
    @State private var colors: [Color] = [
        Color.blue, Color.red
    ]
    
    @State private var progressForAnalycis: Int = 3 // = 3 // 3, 4, 5 - выбирает юзер, но мы не изменяем это

    @State private var currentStage: Int = 19
    @State private var progress: CGFloat = 0
    
    @State private var isSelectedThreeStages: Bool = true
    @State private var isSelectedFourStages: Bool = false
    @State private var isSelectedFiveStages: Bool = false
    
    @State private var isScaledTopCircle: Bool = false
    @State private var isScaledBottomCircle: Bool = false
    @State private var isScaledRightCircle: Bool = false
    @State private var isScaledLeftCircle: Bool = false
        
    @State private var mode: Mode = .beforeStart
    @State private var startTimer: Int = 5 // Время для начала практики
    @State private var showTipText: Bool = true
    @State private var isNeedToShowStartText: Bool = false
    
    let strawberry = Colors.Primary.lavender500Purple
    let dotLength: CGFloat = 1
    
    let animation = Animation
        .linear(duration: 16)
        .delay(1)
    
    
    @StateObject private var timerManager = TimerManager()
    @StateObject private var timerManagerForRemaining = TimerManagerForRemaining() // 57, 76, 95 - максмальное(для отправки на бэк) (19 = (4 + 7 + 8) * 3,4,5 - подходы)
    @StateObject private var timerManagerForProgress = TimerManagerForProgress() // 5, 4, 3 - подходы, количество сколько осталось

    // MARK: View
    var body: some View {
        ZStack {
            Image(currentTheme == .none
                  ? "bg-mb-defaultCover"
                  : currentTheme == .birds ? "bg-mb-birdrsCover"
                  : currentTheme == .ocean ? "bg-mb-oceanCover"
                  : currentTheme == .nightInForest ? "bg-mb-nightInForestCover"
                  : currentTheme == .rain ? "bg-mb-rainCover" : "bg-mb-defaultCover")
            .resizable()
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Rectangle()
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .background(
                        LinearGradient(colors: [Color(hex: "BBBAFF"), Color(hex: "973FF4")], startPoint: .top, endPoint: .bottom)
                    )
                    .opacity(0.4)
            )
            
            VStack {
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 3))
                        .foregroundStyle(getColorForMainCircle(for: currentTheme))
                        .overlay {
                            Circle()
                                .trim(from: CGFloat(1 - Double(currentStage) / 19), to: 1) // Привязка к 1 подходу по времени - 19 сек
                                .stroke(strawberry, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .rotationEffect(Angle(degrees: -90))
                                .animation(.linear(duration: 1.0), value: currentStage)
                        }
                    Text("\(progressForPractice)") // Показываем кол оставшихся подходов
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(width: 30, height: 30)
                .padding(.top, 10) //90
                .onReceive(timerManagerForRemaining.$counter) { newCount in
                    if newCount > 0 {
                        if newCount == 19 {
                            self.generateHapticFeedbackForDots()
                            withAnimation(.linear) {
                                self.breathIn = true
                            }
                        } else if newCount == 15 {
                            self.generateHapticFeedbackForDots()
                            withAnimation(.linear) {
                                self.breathIn = false
                                self.hold = true
                            }
                        } else if newCount == 8 {
                            self.generateHapticFeedbackForDots()
                            withAnimation(.linear) {
                                self.hold = false
                                self.breathOut = true
                            }
                        } else if newCount == 0 {
                            self.generateHapticFeedbackForDots()
                            self.breathIn = true
                        }
                    } else if newCount == 0 {
                        self.generateHapticFeedbackForDots()
                        self.breathOut = false
                        
                        progressForPractice -= 1
                        
                        if progressForPractice == 0 {
                            timerManagerForRemaining.stopTimer()
                            mode = .end
                            isSheetFinishPresent.toggle()
                        }
                    }
                }
                .opacity(mode == .proccess ? 0.5 : 0)
                .animation(.linear(duration: 0.3), value: mode)
                
                ZStack {
                    ZStack {
                        gradientView()
                        
                        ring(for: strawberry)
                            .frame(width: 340)
                            .animation(animation, value: drawingStroke)
                            .onAppear {
                                drawingStroke.toggle()
                            }
                            .onReceive(timerManagerForRemaining.$counter) { newCount in
                                if newCount >= 0 {
                                    currentStage = newCount
                                    
                                    if currentStage == 19 {
                                        withAnimation {
                                            isScaledTopCircle.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                isScaledTopCircle.toggle()
                                            }
                                        }
                                    }
                                    
                                    if currentStage == 15 {
                                        withAnimation {
                                            isScaledRightCircle.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                isScaledRightCircle.toggle()
                                            }
                                        }
                                    }
                                    
                                    if currentStage == 8 {
                                        withAnimation {
                                            isScaledLeftCircle.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                isScaledLeftCircle.toggle()
                                            }
                                        }
                                    }
                                }
                            }
                        
                        ZStack {
                            Circle()
                                .stroke(getColorForSideCircrles(for: currentTheme).opacity(0.8), style: StrokeStyle(lineWidth: 3, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLength, 15.0], dashPhase: 0))
                                .frame(width: 340, height: 340)
                                .scaleEffect(breathIn ? 1.2 : 1.0)
                                .scaleEffect(hold ? 1.3 : 1.2)
                                .scaleEffect(breathOut ? 1.0 : 1.2)
                                .animation(.linear(duration: breathIn ? 4.0 : hold ? 7.0 : breathOut ? 8.0 : 0))
                            
                            Circle()
                                .stroke(getColorForSideCircrles(for: currentTheme).opacity(0.6), style: StrokeStyle(lineWidth: 3, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLength, 15.0], dashPhase: 0))
                                .frame(width: 340, height: 340)
                                .scaleEffect(breathIn ? 1.3: 1.0)
                                .scaleEffect(hold ? 1.4 : 1.3)
                                .scaleEffect(breathOut ? 1.0 : 1.3)
                                .animation(.linear(duration: breathIn ? 4.0 : hold ? 7.0 : breathOut ? 8.0 : 0))
                            
                            Circle()
                                .stroke(getColorForSideCircrles(for: currentTheme).opacity(0.3), style: StrokeStyle(lineWidth: 3, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLength, 15.0], dashPhase: 0))
                                .frame(width: 340, height: 340)
                                .scaleEffect(breathIn ? 1.3 : 1.0)
                                .scaleEffect(hold ? 1.5 : 1.4)
                                .scaleEffect(breathOut ? 1.0 : 1.3)
                                .animation(.linear(duration: breathIn ? 4.0 : hold ? 7.0 : breathOut ? 8.0 : 0))
                        }
                        .opacity(mode == .proccess ? 1 : 0)
                        .animation(.linear(duration: 0.3), value: mode)
                        
                        createTopCircleView()
                            .opacity(mode == .proccess ? 1 : 0)
                            .animation(.linear(duration: 0.3), value: mode)
                        createRightCircleView()
                            .opacity(mode == .proccess ? 1 : 0)
                            .animation(.linear(duration: 0.3), value: mode)
                        createLeftCircleView()
                            .opacity(mode == .proccess ? 1 : 0)
                            .animation(.linear(duration: 0.3), value: mode)
                    }
                    
                    ZStack {
                        Text(isNeedToShowStartText ? "Приготовся, начнем через\n\(startTimer)" : "")
                            .foregroundColor(snow)
                            .multilineTextAlignment(.center)
                            .opacity(startTimer == 0 ? 0 : 1)
                            .animation(.linear(duration: 1.0))
                        
                        Text("Выдыхай")
                            .foregroundColor(snow.opacity(mode == .proccess ? 1 : 0))
                            .multilineTextAlignment(.center)
                            .scaleEffect(breathOut ? 0.3 : 2.3)
                            .animation(.linear(duration: 8.0))
                            .opacity(breathOut ? 1 : 0)
                        
                        Text("Удерживай")
                            .foregroundColor(snow.opacity(mode == .proccess ? 1 : 0))
                            .multilineTextAlignment(.center)
                            .scaleEffect(hold ? 1.12 : 1)
                            .animation(.linear(duration: 1.0).repeatForever())
                            .opacity(hold ? 1 : 0)
                        
                        Text("Вдыхай")
                            .foregroundColor(snow.opacity(mode == .proccess ? 1 : 0))
                            .multilineTextAlignment(.center)
                            .scaleEffect(breathIn ? 2.3 : 0.3)
                            .animation(.linear(duration: 4.0))
                            .opacity(breathIn ? 1 : 0)
                        
                    }
                }
                .padding(.top, -60)
                
                VStack{
                    MTButton(buttonStyle: .fill, title: "Завершить") {
                        
                        self.mode = .end
                        self.soundPlayer.audioPlayer = nil
                        self.timerManagerForRemaining.stopTimer()
                        
                        #warning("TODO: В будущем реализовать паузу")
//                        if progressForAnalycis == 0 {
//                        else {
//                            self.mode = .pause
//                            self.soundPlayer.audioPlayer?.pause()
//                            self.timerManagerForRemaining.isPaused = true
//                        }
//
                        if progressForAnalycis == 3 {
                            if progressForPractice == 2 || progressForPractice == 1 || progressForPractice == 0 {
                                self.dismissAction(true)
                            }
                        } else if progressForAnalycis == 4 {
                            if progressForPractice == 2 || progressForPractice == 1 || progressForPractice == 0 {
                                self.dismissAction(true)
                            }
                        } else if progressForAnalycis == 5 {
                            if progressForPractice == 3 || progressForPractice == 2 || progressForPractice == 1 || progressForPractice == 0 {
                                self.dismissAction(true)
                            }
                        }
                        
                        sendMetrics()
                        
                        withAnimation {
                            self.isSheetFinishPresent.toggle()
                        }
                    }
                    .frame(maxHeight: 48)
                    .padding(.horizontal, 11)
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 34, height: 20, alignment: .center)
                        .padding(.top, 25)
                }
                .opacity(mode == .proccess ? 1 : 0)
                .animation(.linear(duration: 0.5), value: mode)
                .padding(.bottom, 50)
                .padding(.horizontal, 21)
            
            }
            .onReceive(timerManager.$counter) { newCounterValue in
                startTimer = newCounterValue
                
//                if newCounterValue == 1 {
//                    self.mode = .proccess
//                }
                
                if newCounterValue == 0 {
                    showTipText = false
                    isNeedToShowStartText = false
                    timerManagerForRemaining.startTimer()
                                    
                    if currentTheme == .nightInForest {
                        soundPlayer.soundName = "nightInForest"
                        soundPlayer.playSound()
                    } else if currentTheme == .ocean {
                        soundPlayer.soundName = "ocean"
                        soundPlayer.playSound()
                    } else if currentTheme == .birds {
                        soundPlayer.soundName = "birds"
                        soundPlayer.playSound()
                    } else if currentTheme == .rain {
                        soundPlayer.soundName = "rainSound"
                        soundPlayer.playSound()
                    } else {
                        soundPlayer.audioPlayer = nil
                    }
                    
                    self.mode = .proccess
                    timerManager.stopTimer()
                }
            }
            
            // Завершение практики
            if isSheetFinishPresent {
                VStack {}
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                    .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                                 switchablePositions: [.dynamicTop]) {
                        VStack(spacing: 0) {
                            Text("Завершение практики")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Colors.Primary.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 10)
                                .padding(.top, 24)
                            
                            VStack {
                                Text(getTextForProgress(maxProgress: progressForAnalycis, currentProgress: progressForPractice))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Colors.Primary.blue)
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.top, 11)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                ProgressView(value: 1 - (CGFloat(progressForPractice) / CGFloat(progressForAnalycis)))
                                    .frame(maxWidth: .infinity, maxHeight: 24, alignment: .topLeading)
                                    .padding(.top, 22)
                                    .progressViewStyle(BarProgressStyle(color: Colors.Primary.lavender500Purple, height: 24, labelFontStyle: .system(size: 16)))
                                                              
                                HStack(spacing: 20) {
                                    Image("ic-cm-handsLove")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text(getAdviceForProgress(maxProgress: progressForAnalycis, currentProgress: progressForPractice))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(Colors.Primary.lavender500Purple)
                                        .font(.system(size: 16, weight: .medium))
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 31)
                            }
                            
                            VStack {
                                #warning("TODO: В будущем реализовать Паузу, трабла с анимациями ")
//                                if progressForPractice != 0 {
//                                    MTButton(buttonStyle: .fill, title: "Продолжить") {
//                                        withAnimation {
//                                            bottomSheetPosition = .absolute(0)
//
//                                            if currentTheme == .nightInForest {
//                                                soundPlayer.soundName = "nightInForest"
//                                                soundPlayer.playSound()
//                                            } else if currentTheme == .ocean {
//                                                soundPlayer.soundName = "ocean"
//                                                soundPlayer.playSound()
//                                            } else if currentTheme == .birds {
//                                                soundPlayer.soundName = "birds"
//                                                soundPlayer.playSound()
//                                            } else if currentTheme == .rain {
//                                                soundPlayer.soundName = "rainSound"
//                                                soundPlayer.playSound()
//                                            } else {
//                                                soundPlayer.audioPlayer = nil
//                                            }
//                                            self.mode = .proccess
//                                            self.timerManagerForRemaining.isPaused = false
//
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                                                withAnimation {
//                                                    self.isSheetFinishPresent.toggle()
//                                                    self.bottomSheetPosition = .dynamicTop
//                                                }
//                                            }
//                                        }
//                                    }
//                                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
//                                    .padding(.top, 30)
//                                }
//
                                MTButton(buttonStyle: .outline, title: "Завершить") {
                                    soundPlayer.audioPlayer = nil
                                    
                                    withAnimation {
                                        bottomSheetPosition = .absolute(0)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                dismiss.callAsFunction()
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                                .padding(.top, 30)
                                .padding(.bottom, 20)
                            }
                        }
                        .padding(.horizontal, 21)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                    }
                    .customBackground(
                        Color.white
                            .cornerRadius(16, corners: [.topLeft, .topRight])
                            .shadow(color: .white, radius: 0, x: 0, y: 0)
                    )
                    .enableTapToDismiss(false)
                    .enableSwipeToDismiss(false)
                    .enableContentDrag(false)
                    .onDismiss {
                        bottomSheetPosition = .absolute(0)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.isSheetCountStatePresent.toggle()
                            self.bottomSheetPosition = .dynamicTop
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            progressForAnalycis = progressForPractice
            timerManager.startTimer()
            isNeedToShowStartText = true
        }
        .interactiveDismissDisabled()
    }
    
    private func generateHapticFeedbackForDots() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @ViewBuilder
    private func gradientView() -> some View {
        if breathIn {
            LinearGradient(gradient: Gradient(colors: [.gray, .green]), startPoint: .bottom, endPoint: .top)
                .mask(
                    Circle()
                        .frame(width: 160, height: 160)
                        .blur(radius: 70)
                        .opacity(0.9)
                )
                .animation(.linear, value: currentStage)
        } else if hold {
            LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: .bottom, endPoint: .top)
                .mask(
                    Circle()
                        .frame(width: 160, height: 160)
                        .blur(radius: 70)
                        .opacity(0.9)
                )
                .animation(.linear, value: currentStage)
        } else if breathOut {
            LinearGradient(gradient: Gradient(colors: [.cyan, .cyan]), startPoint: .bottom, endPoint: .top)
                .mask(
                    Circle()
                        .frame(width: 160, height: 160)
                        .blur(radius: 70)
                        .opacity(0.9)
                )
                .animation(.linear, value: currentStage)
        } else {
            LinearGradient(gradient: Gradient(colors: [.purple, .red]), startPoint: .bottom, endPoint: .top)
                .mask(
                    Circle()
                        .frame(width: 160, height: 160)
                        .blur(radius: 70)
                        .opacity(0.9)
                )
                .animation(.linear, value: currentStage)
        }
    }
    
    private func getColorForMainCircle(for theme: BreathViewComponentThemes) -> Color {
        switch theme {
        case .none:
            return Color(hex: "11AADF")
        case .birds:
            return Color(hex: "9B3FF4")
        case .ocean:
            return Color(hex: "B283E4")
        case .nightInForest:
            return Color(hex: "B283E4")
        case .rain:
            return Color(hex: "9B3FF4")
        }
    }
    
    private func getColorForSubCircle(for theme: BreathViewComponentThemes) -> Color {
        switch theme {
        case .none:
            return Color(hex: "FFC794")
        case .birds:
            return Color(hex: "FFC794")
        case .ocean:
            return Color(hex: "11AADF")
        case .nightInForest:
            return Color(hex: "11AADF")
        case .rain:
            return Color(hex: "FFC794")
        }
    }
    
    private func getColorForSideCircrles(for theme: BreathViewComponentThemes) -> Color {
        switch theme {
        case .none:
            return Color(hex: "FFC794")
        case .birds:
            return Color(hex: "FFC794")
        case .ocean:
            return Color(hex: "11AADF")
        case .nightInForest:
            return Color(hex: "11AADF")
        case .rain:
            return Color(hex: "FFC794")
        }
    }
    
    private func sendMetrics() {
        if progressForAnalycis == 3 {
            if progressForPractice == 3 {
                Services.metricsService.sendEventWith(eventName: .endEarlyBreathPracice)
                Services.metricsService.sendEventWith(eventType: .endEarlyBreathPracice)
            }
            if progressForPractice == 2 {
                Services.metricsService.sendEventWith(eventName: .endHalfBreathPractice)
                Services.metricsService.sendEventWith(eventType: .endHalfBreathPractice)
            }
            if progressForPractice == 1 || progressForPractice == 0 {
                Services.metricsService.sendEventWith(eventName: .endFullBreathPractice)
                Services.metricsService.sendEventWith(eventType: .endFullBreathPractice)
            }
        } else if progressForAnalycis == 4 {
            if progressForPractice == 4 || progressForPractice == 3 {
                Services.metricsService.sendEventWith(eventName: .endEarlyBreathPracice)
                Services.metricsService.sendEventWith(eventType: .endEarlyBreathPracice)
            }
            if progressForPractice == 2 {
                Services.metricsService.sendEventWith(eventName: .endHalfBreathPractice)
                Services.metricsService.sendEventWith(eventType: .endHalfBreathPractice)
            }
            if progressForPractice == 1 || progressForPractice == 0 {
                Services.metricsService.sendEventWith(eventName: .endFullBreathPractice)
                Services.metricsService.sendEventWith(eventType: .endFullBreathPractice)
            } else if progressForAnalycis == 5 {
                if progressForPractice == 5 || progressForPractice == 4 {
                    Services.metricsService.sendEventWith(eventName: .endEarlyBreathPracice)
                    Services.metricsService.sendEventWith(eventType: .endEarlyBreathPracice)
                }
                if progressForPractice == 3 || progressForPractice == 2 {
                    Services.metricsService.sendEventWith(eventName: .endHalfBreathPractice)
                    Services.metricsService.sendEventWith(eventType: .endHalfBreathPractice)
                }
                if progressForPractice == 1 || progressForPractice == 0 {
                    Services.metricsService.sendEventWith(eventName: .endFullBreathPractice)
                    Services.metricsService.sendEventWith(eventType: .endFullBreathPractice)
                }
            }
        }
    }
     
    @ViewBuilder
    private func ring(for color: Color) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 5))
            .foregroundStyle(getColorForMainCircle(for: currentTheme))
            .overlay {
                ZStack {
                    Circle()
                        .trim(from: CGFloat(1 - Double(currentStage) / 19), to: 1) // Привязка к 1 подходу по времени - 19 сек
                        .stroke(getColorForSubCircle(for: currentTheme),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .animation(.linear, value: currentStage)
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .trim(from: CGFloat(1 - Double(currentStage) / 19), to: 1) // Привязка к 1 подходу по времени - 19 сек
                        .stroke(getColorForSubCircle(for: currentTheme),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .blur(radius: 5)
                        .animation(.linear, value: currentStage)
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .trim(from: CGFloat(1 - Double(currentStage) / 19), to: 1) // Привязка к 1 подходу по времени - 19 сек
                        .stroke(getColorForSubCircle(for: currentTheme),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .blur(radius: 3)
                        .animation(.linear, value: currentStage)
                        .rotationEffect(Angle(degrees: -90))
                }
            }
    }
    
    @ViewBuilder
    private func createTopCircleView() -> some View {
        
        ZStack {
            Circle()
                .frame(width: 25 * (isScaledTopCircle ? 1.1 : 1), height: 25 * (isScaledTopCircle ? 1.1 : 1))
                .foregroundColor(snow)
                .rotationEffect(.degrees(180))
                .offset(y: -170)
            
            Circle()
                .frame(width: 25 * (isScaledTopCircle ? 1.1 : 1), height: 25 * (isScaledTopCircle ? 1.1 : 1))
                .foregroundColor(snow)
                .offset(y: -170)
                .blur(radius: isScaledTopCircle ? 30 : 20)
        }
    }
    
    @ViewBuilder
    private func createLeftCircleView() -> some View {
        
        ZStack {
            Circle()
                .frame(width: 25 * (isScaledLeftCircle ? 1.1 : 1), height: 25 * (isScaledLeftCircle ? 1.1 : 1))
                .foregroundColor(snow)
                .offset(x: -90, y: 145)
            
            Circle()
                .frame(width: 25 * (isScaledLeftCircle ? 1.1 : 1), height: 25 * (isScaledLeftCircle ? 1.1 : 1))
                .foregroundColor(snow)
                .offset(x: -90, y: 145)
                .blur(radius: isScaledLeftCircle ? 30 : 20)
        }
    }
    
    @ViewBuilder
    private func createRightCircleView() -> some View {
        ZStack {
            Circle()
                .frame(width: 25 * (isScaledRightCircle ? 1.1 : 1), height: 25 * (isScaledRightCircle ? 1.1 : 1))
                .foregroundColor(snow)
                .offset(x: 166, y: -35)
            
            Circle()
                .frame(width: 25 * (isScaledRightCircle ? 1.1 : 1), height: 25 * (isScaledRightCircle ? 1.1 : 1))
                .foregroundColor(snow)
                .offset(x: 166, y: -35)
                .blur(radius: isScaledRightCircle ? 30 : 20)
        }
    }
    
    // MARK: - Anylicts
    private func getTextForProgress(maxProgress: Int, currentProgress: Int) -> String {
        var text: String = ""
        // Если юзер выбрал 3 подхода
        if maxProgress == 3 {
            if currentProgress == 3 {
                text = "Твой прогресс по дыхательной практики не будут засчитан. В будущем, чтобы достигнуть результата нужно выполнить 30% практики минимум!"
            }
            if currentProgress == 2 {
                text = "Молодец! Мы засчитали твой прогресс, но советуем выполнять всю практику полностью"
            }
            if currentProgress == 1 || currentProgress == 0 {
                text = "Отличная работа! Мы сохранили твое достижение цели, продолжай заниматься дыхательной практикой каждый день, чтобы научиться контролировать свое эмоциональное равновесие!"
            }
        } else if maxProgress == 4 {
            if currentProgress == 4 || currentProgress == 3 {
                text = "Твой прогресс по дыхательной практики не будут засчитан. В будущем, чтобы достигнуть результата нужно выполнить 30% практики минимум!"
            }
            if currentProgress == 2 {
                text = "Молодец! Мы засчитали твой прогресс, но советуем выполнять всю практику полностью"
            }
            if currentProgress == 1 || currentProgress == 0 {
                text = "Отличная работа! Мы сохранили твое достижение цели, продолжай заниматься дыхательной практикой каждый день, чтобы научиться контролировать свое эмоциональное равновесие!"
            }
        } else if maxProgress == 5 {
            if currentProgress == 5 || currentProgress == 4 {
                text = "Твой прогресс по дыхательной практики не будут засчитан. В будущем, чтобы достигнуть результата нужно выполнить 30% практики минимум!"
            }
            if currentProgress == 3 || currentProgress == 2 {
                text = "Молодец! Мы засчитали твой прогресс, но советуем выполнять всю практику полностью"
            }
            if currentProgress == 1 || currentProgress == 0 {
                text = "Отличная работа! Мы сохранили твое достижение цели, продолжай заниматься дыхательной практикой каждый день, чтобы научиться контролировать свое эмоциональное равновесие!"
            }
        } else {
            text = "MaxProgressNotFound!"
        }
        
        return text
    }
    
    private func getAdviceForProgress(maxProgress: Int, currentProgress: Int) -> String {
        
        var text: String = ""
        if maxProgress == 3 {
            if currentProgress == 3 {
                text = "Даже небольшая практика может помочь снизить твой уровень стресса и тревожности"
            }
            if currentProgress == 2 {
                text = "Регулярная практика помогает более эффективно справляться со стрессом и адаптироваться к нему"
            }
            if currentProgress == 1 || currentProgress == 0 {
                text = "Используй дыхание для эффективного управления своими эмоциями и реакциями"
            }
        } else if maxProgress == 4 {
            if currentProgress == 4 || currentProgress == 3 {
                text = "Даже небольшая практика может помочь снизить твой уровень стресса и тревожности"
            }
            if currentProgress == 2 {
                text = "Регулярная практика помогает более эффективно справляться со стрессом и адаптироваться к нему"
            }
            if currentProgress == 1 || currentProgress == 0 {
                text = "Используй дыхание для эффективного управления своими эмоциями и реакциями"
            }
        } else if maxProgress == 5 {
            if currentProgress == 5 || currentProgress == 4 {
                text = "Даже небольшая практика может помочь снизить твой уровень стресса и тревожности"
            }
            if currentProgress == 3 || currentProgress == 2 {
                text = "Регулярная практика помогает более эффективно справляться со стрессом и адаптироваться к нему"
            }
            if currentProgress == 1 || currentProgress == 0 {
                text = "Используй дыхание для эффективного управления своими эмоциями и реакциями"
            }
        } else {
            text = "MaxProgressNotFound!"
        }
        
        return text
    }
}


struct BarProgressStyle: ProgressViewStyle {
 
    var color: Color = .purple
    var height: Double = 20.0
    var labelFontStyle: Font = .body
    
    var backgroundColor: UIColor = .systemGray5
 
    func makeBody(configuration: Configuration) -> some View {
 
        let progress = configuration.fractionCompleted ?? 0.0

        GeometryReader { geometry in
            VStack(alignment: .leading) {
                configuration.label
                    .font(labelFontStyle)
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(uiColor: backgroundColor))
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(color)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
                                    currentValueLabel
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
 
            }
 
        }
    }
}
