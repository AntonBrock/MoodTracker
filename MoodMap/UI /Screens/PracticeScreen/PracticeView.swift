//
//  PracticeView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 14.11.2023.
//

import SwiftUI

struct PracticeView: View {
    
    var animation: Namespace.ID
    
    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: PracticeViewCoordinator
    @Environment(\.colorScheme) var colorScheme

    @State var wasOpenedFromTabBar: (() -> Void)?
    
    init(
        coordinator: PracticeViewCoordinator,
        animation: Namespace.ID,
        wasOpenedFromTabBar: (() -> Void)? = nil
    ){
        self.coordinator = coordinator
        self.animation = animation
        self.viewModel = coordinator.viewModel
        self.viewModel.setupViewer(self)
        self.wasOpenedFromTabBar = wasOpenedFromTabBar
        
        if wasOpenedFromTabBar != nil {
            wasOpenedFromTabBar!()
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    diaryBlock()
                    moodBreathView()
                }
            }
            .onAppear {
                viewModel.setupViewer(self)
                
                if coordinator.parent.isNeedShowAuthPopupFromLaunchScreen && AppState.shared.isLogin == false {
                    withAnimation {
                        coordinator.parent.showAuthLoginView = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func diaryBlock() -> some View {
        Text("Эмоциональная поддержка")
            .foregroundColor(colorScheme == .dark ? .white : Colors.Primary.blue)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
        
        createDiaryView()
            .padding(.top, 10)
            .onTapGesture {
                if AppState.shared.isLogin ?? false {
                    Services.metricsService.sendEventWith(eventName: .openDiaryScreenButton)
                    Services.metricsService.sendEventWith(eventType: .openDiaryScreenButton)
                    
                    coordinator.openDiary()
                } else {
                    withAnimation {
                        coordinator.parent.showAuthLoginView = true
                    }
                }
            }
    }
    
    
    @ViewBuilder
    private func createDiaryView() -> some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Image("ic-pc-diaryCover")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .aspectRatio(1, contentMode: .fill)
                
                Text("Дневник\nблагодарности")
                    .foregroundColor(.white )
                    .font(.system(size: 22, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.leading, 26)
                    .padding(.bottom, 26)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .shadow(color:  colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mischka500,
                radius: 3.0, x: 1.0, y: 0)
    }
    
    
    @ViewBuilder
    private func moodBreathView() -> some View {
        Text("Практики")
            .foregroundColor(colorScheme == .dark ? .white : Colors.Primary.blue)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
        
        createSimpleBreathCover()
            .onTapGesture {
                if AppState.shared.isLogin ?? false {
//                    Services.metricsService.sendEventWith(eventName: .openBreathScreen)
//                    Services.metricsService.sendEventWith(eventType: .openBreathScreen)

                    coordinator.openSimpleBreathScreen()
                } else {
                    withAnimation {
                        coordinator.parent.showAuthLoginView = true
                    }
                }
            }
        
        createMoodBreathCover()
            .onTapGesture {
                if AppState.shared.isLogin ?? false {
                    Services.metricsService.sendEventWith(eventName: .openBreathScreen)
                    Services.metricsService.sendEventWith(eventType: .openBreathScreen)

                    coordinator.openBreathScreen()
                } else {
                    withAnimation {
                        coordinator.parent.showAuthLoginView = true
                    }
                }
            }
    }
    
    @ViewBuilder
    private func createSimpleBreathCover() -> some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Image("ic-pc-simpleBreath")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .aspectRatio(1, contentMode: .fill)

                Text("Дыхательная практика\nУпрощенная")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.leading, 26)
                    .padding(.bottom, 26)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .shadow(color:  colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mischka500,
                radius: 3.0, x: 1.0, y: 0)
    }
    
    @ViewBuilder
    private func createMoodBreathCover() -> some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Image("ic-ms-mainBreathCover")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .aspectRatio(1, contentMode: .fill)

                Text("Дыхательная практика\n4-7-8")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.leading, 26)
                    .padding(.bottom, 26)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .shadow(color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mischka500,
                radius: 3.0, x: 1.0, y: 0)
    }
}
