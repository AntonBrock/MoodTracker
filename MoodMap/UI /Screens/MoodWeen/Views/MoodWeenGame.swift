//
//  MoodWeenGame.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 09.10.2023.
//

import SwiftUI

struct MoodWeenGame: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showView = false
    @State private var isUpgrading = false
    @State private var isShake = false
    
    @State private var isShakeProgress: Int = 0
    @State private var currentIndex = 0
    @State private var rotationAngle: Double = 0
    
    @State private var maxValueForGame: Int = 5
    @State private var currentValueGame: Int = 0
    
    @State private var isEnableGame: Bool = false
    
    @State private var remainingTime: TimeInterval = 0
    @State private var isTimerRunning = false
    
    let images = [
        "ic-game-pump-firstState",
        "ic-game-pump-secondState",
        "ic-game-pump-thirdState",
        "ic-game-pump-fourState",
        "ic-game-pump-finalState"
    ]
    
    var body: some View {
        ZStack {
            Image("ic-moodWeen-game-background")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("Следующий уровень через: \(formattedTime)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 20)
                .padding(.trailing, 20)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .opacity(remainingTime != 0.0 ? 1 : 0)
                .transition(.opacity)
            
            VStack {
                Image(images[currentIndex])
                    .resizable()
                    .frame(maxWidth: 251, maxHeight: 241)
                    .offset(x: isShake ? 60 : 0)
                    .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
                    .rotation3DEffect(.degrees(isUpgrading ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .animation(.default, value: isUpgrading)
                    .animation(.default, value: isShake)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onChanged { _ in
                                                                
                                isShake = true
                                isShakeProgress += 1
                                
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                if currentIndex != 4 {
                                    if isShakeProgress == 7 {
                                        isShakeProgress = 0
                                        currentIndex = (currentIndex + 1) % images.count
                                        
                                        currentValueGame += 1
//                                        AppState.shared.moodWeenGameStage = currentValueGame
                                        isEnableGame = false
//                                        AppState.shared.moodWeenGameIsEnabled = false
                                        
                                        if currentValueGame == 4 {
                                            remainingTime = 0.0
                                        } else {
                                            remainingTime = 24 * 60 * 60
                                        }
                                        stopTimer()
                                        startTimer()
                                        
                                        isShake = false
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isUpgrading = true
                                        }
                                    }
                                }
                                withAnimation(Animation.spring(response: 0.1, dampingFraction: 0.1, blendDuration: 0.1)) {
                                    isShake = false
                                }
                            }
                            .onEnded { _ in }
                    )
                    .disabled(!isEnableGame)

                Text(currentIndex != 4 ? "Тыкай на тыкву,\nчтобы повысить ее уровень" : "Отличного тебе MoodWeen'а")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 30)
                
                ProgressView(value: CGFloat(CGFloat(((currentValueGame + 1) * 100) / maxValueForGame) / 100))
                    .frame(maxWidth: .infinity, maxHeight: 10, alignment: .bottom)
                    .progressViewStyle(
                        BarProgressStyle(color: Color(hex: "FF9635"), height: 10, labelFontStyle: .system(size: 16), backgroundColor: UIColor(Color(hex: "4872C9")))
                    )
                    .padding(.top, 45)
                    .padding(.horizontal, 24)

                MTButton(buttonStyle: .fill, title: "Назад") {
                    dismiss.callAsFunction()
                }
                .frame(maxWidth: 227, maxHeight: 48, alignment: .bottom)
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 50)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .onAppear {
            if let savedTime = UserDefaults.standard.value(forKey: "remainingTime") as? TimeInterval {
                isTimerRunning = true
                remainingTime = savedTime
            } else {
                remainingTime = 0.0
            }
            
            // Calculate time elapsed since the app was last active and adjust remainingTime
            if let lastActiveDate = UserDefaults.standard.object(forKey: "lastActiveDate") as? Date {
                let elapsedTime = Date().timeIntervalSince(lastActiveDate)
                if elapsedTime < remainingTime {
                    remainingTime -= elapsedTime
                } else {
                    remainingTime = 0.0
                }
            }
                        
            withAnimation {
//                currentValueGame = AppState.shared.moodWeenGameStage
                
                if currentIndex > 0 {
                    currentIndex = currentValueGame - 1
                } else {
                    currentIndex = currentValueGame
                }
            }
            
            if currentValueGame == 0 {
//                AppState.shared.moodWeenGameIsEnabled = true
            }
                        
//            isEnableGame = currentIndex >= 4 ? false : AppState.shared.moodWeenGameIsEnabled
            
            startTimer()
        }
        .onDisappear {
            UserDefaults.standard.set(Date(), forKey: "lastActiveDate")
            stopTimer()
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
        if isTimerRunning {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if remainingTime > 0.0 {
                    remainingTime -= 1
                    UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
                } else {
                    stopTimer()
                    isEnableGame = currentIndex <= 4
                    remainingTime = 0.0
                    timer.invalidate()
                }
            }
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
    }
    
    var formattedTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        return String(format: "%02d Ч : %02d М", hours, minutes)
    }
}
