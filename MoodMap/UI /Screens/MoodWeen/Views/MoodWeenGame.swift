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
            
            VStack {
                Image(images[currentIndex])
                    .resizable()
                    .frame(maxWidth: 251, maxHeight: 241)
                    .offset(x: isShake ? 30 : 0)
                    .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
                    .rotation3DEffect(.degrees(isUpgrading ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .animation(.default, value: isUpgrading)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onChanged { _ in
                                if !isUpgrading {
                                    isShake = true
                                    isShakeProgress += 1
                                    
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    if isShakeProgress == 7 {
                                        isShakeProgress = 0
                                        currentIndex = (currentIndex + 1) % images.count
                                        isShake = false
                                        
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isUpgrading = true
                                        }
                                    }
                                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                                        isShake = false
                                    }
                                }
                            }
                            .onEnded { _ in }
                    )

                Text("Тыкай на тыкву,\nчтобы повысить ее уровень")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 30)

                MTButton(buttonStyle: .fill, title: "Назад") {
                    dismiss.callAsFunction()
                }
                .frame(maxWidth: 227, maxHeight: 48, alignment: .bottom)
                .padding(.top, 45)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 50)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}
