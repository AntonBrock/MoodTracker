//
//  BreathView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.08.2023.
//

import SwiftUI
import BottomSheet

struct BreathView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: BreathViewCoordinator
    
    @State private var isBreathComponentVisible = false

    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop
    
    @State private var isSheetCountStatePresent = false
    @State private var isSheetThemesesPresent = false
    
    @State private var isSelectedThreeStages: Bool = true
    @State private var isSelectedFourStages: Bool = false
    @State private var isSelectedFiveStages: Bool = false

    @State private var progressForPractice: Int = 3 // 3, 4, 5 - выбирает юзер
    @State var progressForAnalycis: Int = 3 // 3, 4, 5 - выбирает юзер, но мы не изменяем это
    @State private var textForButton: String = "Начать ~ 0:57 мин"
    
    // Themes
    @State var currentTheme: BreathViewComponentThemes = .none
    
    // MARK: - Init
    init(
        coordinator: BreathViewCoordinator
    ) {
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
        
        viewModel.setupViewer(self)
    }
        
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
                Text("Дыхательная\nпрактика")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal, 24)

                HStack {
                    Text("Тема - \(currentTheme == .birds ? "птицы" : currentTheme == .ocean ? "океан" : currentTheme == .nightInForest ? "ночь в лесу" : currentTheme == .rain ? "дождь" : "нет")")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .regular))
                    
                    Text("/ \(progressForPractice) \(progressForPractice == 3 ? "подхода" : progressForPractice == 4 ? "подхода" : "подходов")")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .regular))
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 5)
                .padding(.horizontal, 24)
                
                Text("\(getTextForPractice(withTheme: currentTheme))\n\nЭта практика поможет постепенно научиться самостоятельно справляться со стрессом и эмоциональными перегрузками.")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .medium))
                    .padding(.top, 26)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                VStack {
                    HStack {
                        CircularButtonWithIcon(
                            action: {
                                self.generateHapticFeedbackForPopups()
                                
                                withAnimation {
                                    self.isSheetCountStatePresent.toggle()
                                }
                            },
                            imageName: "ic-al-mb-progress",
                            buttonColor: .clear,
                            iconColor: Colors.Primary.moonRaker300Purple,
                            borderColor: Colors.Primary.moonRaker300Purple,
                            borderWidth: 1,
                            imageWidth: 16,
                            imageHeight: 12
                        )
                        .padding()
                        
                        Button("\(textForButton)") {
                            
                            sendMetrics()
                            isBreathComponentVisible.toggle()
                        }
                        .buttonStyle(MTButton.CBButtonStyle(buttonColorStyle: .fill))
                        .frame(maxHeight: 48)
                        .padding(.horizontal, 11)
                        
                        CircularButtonWithIcon(
                            action: {
                                self.generateHapticFeedbackForPopups()
                                
                                withAnimation {
                                    self.isSheetThemesesPresent.toggle()
                                }
                            },
                            imageName: "ic-al-mb-bell",
                            buttonColor: .clear,
                            iconColor: Colors.Primary.moonRaker300Purple,
                            borderColor: Colors.Primary.moonRaker300Purple,
                            borderWidth: 1,
                            imageWidth: 20,
                            imageHeight: 20
                        )
                        .padding()
                        
                    }
                    .padding(.horizontal, 22)
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 34, height: 20, alignment: .center)
                        .padding(.top, 25)
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, -20)
            
            if isSheetCountStatePresent {
                VStack {}
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                    .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                                 switchablePositions: [.dynamicTop]) {
                        VStack(spacing: 0) {
                            Button {
                                withAnimation {
                                    bottomSheetPosition = .absolute(0)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation {
                                            self.isSheetCountStatePresent.toggle()
                                            self.bottomSheetPosition = .dynamicTop
                                        }
                                    }
                                }
                            } label: {
                                Image("crossIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.top, 24)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Количество подходов")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Colors.Primary.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 10)
                                .padding(.top, 24)
                            
                            HStack {
                                MMButtonSelecting(title: "3", handle: {
                                    textForButton = "Начать ~ 0:57 мин"
                                    progressForPractice = 3
                                    progressForAnalycis = 3
                                    
                                    isSelectedThreeStages = true
                                    isSelectedFourStages = false
                                    isSelectedFiveStages = false
                                    
                                }, isSelectedButton: $isSelectedThreeStages)
                                .frame(width: 90, height: 44, alignment: .leading)
                                
                                MMButtonSelecting(title: "4", handle: {
                                    textForButton = "Начать ~ 1:16 мин"
                                    progressForPractice = 4
                                    progressForAnalycis = 4
                                    
                                    isSelectedThreeStages = false
                                    isSelectedFourStages = true
                                    isSelectedFiveStages = false
                                }, isSelectedButton: $isSelectedFourStages)
                                .frame(width: 90, height: 44, alignment: .center)

                                MMButtonSelecting(title: "5", handle: {
                                    textForButton = "Начать ~ 1:35 мин"
                                    progressForPractice = 5
                                    progressForAnalycis = 5
                                    
                                    isSelectedThreeStages = false
                                    isSelectedFourStages = false
                                    isSelectedFiveStages = true
                                }, isSelectedButton: $isSelectedFiveStages)
                                .frame(width: 90, height: 44, alignment: .trailing)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 45)
                            .padding(.bottom, 45)
                                
                            
                            MTButton(buttonStyle: .fill, title: "Выбрать") {
                                withAnimation {
                                    bottomSheetPosition = .absolute(0)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation {
                                            self.isSheetCountStatePresent.toggle()
                                            self.bottomSheetPosition = .dynamicTop
                                        }
                                    }
                                }
                            }
                            .frame(width: 230, height: 48, alignment: .center)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                    }
                    .customBackground(
                        Color.white
                            .cornerRadius(16, corners: [.topLeft, .topRight])
                            .shadow(color: .white, radius: 0, x: 0, y: 0)
                    )
                    .enableTapToDismiss(true)
                    .enableSwipeToDismiss(true)
                    .onDismiss {
                        bottomSheetPosition = .absolute(0)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.isSheetCountStatePresent.toggle()
                            self.bottomSheetPosition = .dynamicTop
                        }
                    }
            }
            
            // Выбор Темы
            if isSheetThemesesPresent {
                VStack {}
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                    .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                                 switchablePositions: [.dynamicTop]) {
                        VStack(spacing: 0) {
                            Button {
                                withAnimation {
                                    bottomSheetPosition = .absolute(0)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation {
                                            self.isSheetThemesesPresent.toggle()
                                            self.bottomSheetPosition = .dynamicTop
                                        }
                                    }
                                }
                            } label: {
                                Image("crossIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.top, 24)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Тема")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Colors.Primary.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 10)
                                .padding(.top, 24)
                            
                            VStack {
                                Button {
                                    currentTheme = .none
                                    withAnimation {
                                        bottomSheetPosition = .absolute(0)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                self.isSheetThemesesPresent.toggle()
                                                self.bottomSheetPosition = .dynamicTop
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Без музыки")
                                        .foregroundColor(currentTheme == .none ? Colors.Primary.honeyFlower700Purple : Colors.Primary.blue)
                                        .frame(maxWidth: UIScreen.main.bounds.width)
                                        .font(.system(size: 16))
                                }
                                
                                Button {
                                    currentTheme = .birds
                                    withAnimation {
                                        bottomSheetPosition = .absolute(0)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                self.isSheetThemesesPresent.toggle()
                                                self.bottomSheetPosition = .dynamicTop
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Птицы")
                                        .foregroundColor(currentTheme == .birds ? Colors.Primary.honeyFlower700Purple : Colors.Primary.blue)
                                        .frame(maxWidth: UIScreen.main.bounds.width)
                                        .font(.system(size: 16))
                                }
                                .padding(.top, 24)
                                
                                Button {
                                    currentTheme = .ocean
                                    withAnimation {
                                        bottomSheetPosition = .absolute(0)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                self.isSheetThemesesPresent.toggle()
                                                self.bottomSheetPosition = .dynamicTop
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Океан")
                                        .foregroundColor(currentTheme == .ocean ? Colors.Primary.honeyFlower700Purple : Colors.Primary.blue)
                                        .frame(maxWidth: UIScreen.main.bounds.width)
                                        .font(.system(size: 16))
                                }
                                .padding(.top, 24)
                                
                                Button {
                                    currentTheme = .nightInForest
                                    withAnimation {
                                        bottomSheetPosition = .absolute(0)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                self.isSheetThemesesPresent.toggle()
                                                self.bottomSheetPosition = .dynamicTop
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Ночь в лесу")
                                        .foregroundColor(currentTheme == .nightInForest ? Colors.Primary.honeyFlower700Purple : Colors.Primary.blue)
                                        .frame(maxWidth: UIScreen.main.bounds.width)
                                        .font(.system(size: 16))
                                }
                                .padding(.top, 24)
                                
                                Button {
                                    currentTheme = .rain
                                    withAnimation {
                                        bottomSheetPosition = .absolute(0)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                self.isSheetThemesesPresent.toggle()
                                                self.bottomSheetPosition = .dynamicTop
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Дождь")
                                        .foregroundColor(currentTheme == .rain ? Colors.Primary.honeyFlower700Purple : Colors.Primary.blue)
                                        .frame(maxWidth: UIScreen.main.bounds.width)
                                        .font(.system(size: 16))
                                }
                                .padding(.top, 24)

                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 45)
                            .padding(.bottom, 45)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                    }
                    .customBackground(
                        Color.white
                            .cornerRadius(16, corners: [.topLeft, .topRight])
                            .shadow(color: .white, radius: 0, x: 0, y: 0)
                    )
                    .enableTapToDismiss(true)
                    .enableSwipeToDismiss(true)
                    .onDismiss {
                        bottomSheetPosition = .absolute(0)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.isSheetThemesesPresent.toggle()
                            self.bottomSheetPosition = .dynamicTop
                        }
                    }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation { [weak coordinator] in
                    guard let coordinator else {
                        return
                    }
                    coordinator.parent.hideCustomTabBar = false
                }
            }
        }
        .sheet(isPresented: $isBreathComponentVisible) {
            BreathViewComponent(dismissAction: { isMinimumProgress in
                if isMinimumProgress {
                    viewModel.sendBreathCheck()
                }
            }, progressForPractice: $progressForAnalycis, currentTheme: $currentTheme)
        }
    }
    
    private func getTextForPractice(withTheme: BreathViewComponentThemes) -> String {
        var text: String = ""
        
        switch withTheme {
        case .none:
            text = "При высоком стрессе, тревоге большинство людей автоматически задерживают дыхание или дышат поверхностно. В купе с сильным напряжением в теле в наш мозг поступает сигнал “опасность” и тревожность нарастает"
        case .birds:
            text = "Пение птиц - это естественный концерт природы. Их чистые и мелодичные голоса наполняют воздух музыкой, принося радость и спокойствие. Наблюдение и слушание за пением птиц может стать источником вдохновения для нашего дыхания. Давайте сопровождать их пением своим собственным ритмичным вдохом и выдохом, обретая гармонию с природой и позволяя этой мелодии унести нас в мир спокойствия и умиротворения"
        case .ocean:
            text = "Океан - это не только бескрайние водные просторы, но и источник вдохновения и спокойствия для многих из нас. Звуки прибоя, морские волны и морской бриз могут пробуждать в нас чувство гармонии и связи с природой. Почувствуйте, как ваши вдохи и выдохи соответствуют волнам, медленно нарастая и убывая, словно прибой"
        case .nightInForest:
            text = "Лес ночью - это загадочное и удивительное место, где природа пробуждается к жизни в тишине и спокойствии. Звуки сверчков, шум деревьев и блеск звезд создают неповторимую атмосферу, которая может помочь нам расслабиться и восстановить внутренний баланс"
        case .rain:
            text = "Дождь - это природный музыкальный инструмент, играющий на струнах листьев и барабанящий по земле своей нежной мелодией. Его ритм и звуки создают гармонию с окружающим миром, напоминая нам о важности внимания к моменту. Прислушайтесь к звукам дождя, дайте им вдохновить вас, и начните дышать в такт этой магии"
        }
        
        return text
    }
    
    private func generateHapticFeedbackForPopups() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func sendMetrics() {
        switch currentTheme {
        case .none:
            Services.metricsService.sendEventWith(eventName: .choosedDefaultThemeBreath)
            Services.metricsService.sendEventWith(eventType: .choosedDefaultThemeBreath)
        case .birds:
            Services.metricsService.sendEventWith(eventName: .choosedBirdsThemeBreath)
            Services.metricsService.sendEventWith(eventType: .choosedBirdsThemeBreath)
        case .ocean:
            Services.metricsService.sendEventWith(eventName: .choosedOceanThemeBreath)
            Services.metricsService.sendEventWith(eventType: .choosedOceanThemeBreath)
        case .nightInForest:
            Services.metricsService.sendEventWith(eventName: .choosedNightForestThemeBreath)
            Services.metricsService.sendEventWith(eventType: .choosedNightForestThemeBreath)
        case .rain:
            Services.metricsService.sendEventWith(eventName: .choosedRainThemeBreath)
            Services.metricsService.sendEventWith(eventType: .choosedRainThemeBreath)
        }
        
        if isSelectedThreeStages {
            Services.metricsService.sendEventWith(eventName: .choosedStepThreeBreath)
            Services.metricsService.sendEventWith(eventType: .choosedStepThreeBreath)
        }
        if isSelectedFourStages {
            Services.metricsService.sendEventWith(eventName: .choosedStepFourBreath)
            Services.metricsService.sendEventWith(eventType: .choosedStepFourBreath)
        }
        if isSelectedFiveStages {
            Services.metricsService.sendEventWith(eventName: .choosedStepFiveBreath)
            Services.metricsService.sendEventWith(eventType: .choosedStepFiveBreath)
        }
    }
}
