//
//  MainView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI
import BottomSheet
import ConfettiSwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: ViewModel
      
    let container: DIContainer
    var animation: Namespace.ID

    private unowned let coordinator: MainViewCoordinator
    
    var formattedTime: String {
        if Int(remainingTime) <= 0 {
           return ""
        } else {
            let days = Int(remainingTime) / (3600 * 24)
            let hours = (Int(remainingTime) % (3600 * 24)) / 3600
            
            var hoursString = ""
            if hours > 0 {
                hoursString = String(format: "%02d ", hours)
                hoursString += (hours == 1 || (days == 0 && hours % 10 == 1 && hours % 100 != 11)) ? "Ч" : "Ч"
            }
            
            return "\(days > 0 ? String(format: "%02d Д ", days) : "")\(hoursString)"
        }
    }
    
    @State var typeSelectedIndex: Int = 0
    
    @State var isAnimated: Bool = false
    @State var isAnimatedJournalView: Bool = false
    @State var isAnimatedMoodCheck: Bool = false
    
    @State var showMoreDetailsAboutJournalPage: Bool = false
    @State var currentSelectedJournalPage: JournalViewModel?
    
    @State var isSheetAboutMoodCheckPresent: Bool = false
    @State var isCompletedMoodCheck: Bool = false
    
    @State var quoteText: String = "Это нормально ‒ испытывать плохие эмоции. Это не делает тебя плохим человеком."
    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop
    
    @State var confettiCannon: Int = 0
    @State var moodWeenShimmerAnimation: Bool = false
    @State var isScalingLeftMoodWeenAnimation: Bool = true
    
    
    // For MoodWeen
    @State private var remainingTime: TimeInterval = 0
    @State private var isTimerRunning = false
    
    let notificationCenter = NotificationCenter.default
    
    init(
        container: DIContainer,
        animation: Namespace.ID,
        coordinator: MainViewCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
        self.animation = animation
        self.viewModel = coordinator.viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if RCValues.sharedInstance.isEnableMainConfiguraation(forKey: .moodWeenEvent) {
                        moodWeenEventBlock()
                            .padding(.top, 16)
                            .onTapGesture {
                                coordinator.parent.isShowingMoodWeenEventScreen = true
                            }
                    }
                    
                    if isAnimated {
                        VStack {
                            createEmotionalHeader()
                                .padding(.top, 12)
                                .transition(.move(edge: .top))
                                .zIndex(99999)
                            
                            if isAnimatedMoodCheck {
                                createMoodCheck(
                                    isCompletedUserCheck: viewModel.moodCheckViewModel.isCheckStateUser,
                                    isCompletedBreathCheck: viewModel.moodCheckViewModel.isBreathActivity,
                                    isCompletedDiaryCheck: viewModel.moodCheckViewModel.isCreateNewDiaryNote
                                )
                                    .shadow(color: Colors.Primary.lavender500Purple.opacity(0.5), radius: 10, x: 0, y: 0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Colors.Primary.lavender500Purple, lineWidth: 1)
                                            .padding(.horizontal, 35)
                                    )
                                    .padding(.top, isCompletedMoodCheck ? -85 : -25)
                                    .transition(.move(edge: .top))
                                    .onTapGesture {
                                        
                                        withAnimation {
                                            bottomSheetPosition = .absolute(0)
                                            self.coordinator.parent.hideCustomTabBar = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                withAnimation {
                                                    isSheetAboutMoodCheckPresent.toggle()
                                                    self.bottomSheetPosition = .dynamicTop
                                                }
                                            }
                                        }
                                    }
                                    .confettiCannon(counter: $confettiCannon, num: 50, confettiSize: 15, rainHeight: 150, openingAngle: Angle.degrees(-120), radius: 300)
                            }
                        }
                    }
                    
                    if !(viewModel.journalViewModels?.isEmpty ?? true) {
                        if isAnimatedJournalView {
                            createJournalView()
                                .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                    }
                    
                    diaryBlock()
                    
                    QuoteView(quote: $quoteText)
                        .padding(.top, 10)
                    
                    moodBreathView()
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
                    
                    Text("Статистика сегодня")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    SegmentedControlView(countOfItems: 2, segments: viewModel.isEnableTypeOfReprot,
                                         selectedIndex: $typeSelectedIndex,
                                         currentTab: viewModel.isEnableTypeOfReprot[typeSelectedIndex])
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                    
                    CircleEmotionChart(
                        emotionStateCounts: $viewModel.emotionCountData.countState,
                        emotionNames: $viewModel.emotionCountData.text,
                        emotionColors: $viewModel.emotionCountData.color,
                        emotionTotal: $viewModel.emotionCountData.total,
                        emotionCircleViewModel: $viewModel.emotionCountData.emotionCircleViewModel,
                        isLoading: $viewModel.isShowLoader,
                        dataIsEmpty: $viewModel.emotionCountData.dataIsEmpty,
                        emotionSlices: $viewModel.pieSliceData
                    )
                    .padding(.top, 16)
                    .padding(.horizontal, 10)
                    
                    DayilyCharts(viewModel: $viewModel.timeData)
                        .padding(.top, 16)
                        .padding(.horizontal, 10)
                        .onChange(of: typeSelectedIndex) { newValue in
                            viewModel.selectedTypeOfReport = typeSelectedIndex
                            viewModel.segmentDidChange()
                        }
                        .padding(.bottom, 90)
                }
            }
            .sheet(isPresented: $showMoreDetailsAboutJournalPage, content: {
                DetailJournalView(
                    showMoreInfo: $showMoreDetailsAboutJournalPage,
                    model: $currentSelectedJournalPage,
                    shareStateAction: { model in
                        coordinator.parent.journalCoordinator.viewModel.sharingJournalViewModel = model
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            coordinator.parent.isShowingSharingScreen = true
                        }
                    }
                )
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .leading)
            })
            .onAppear {
                viewModel.setupViewer(self)
                
                withAnimation(.linear(duration: 0.3)) {
                    self.isAnimated = true
                }
                
                if coordinator.parent.isNeedShowAuthPopupFromLaunchScreen && AppState.shared.isLogin == false {
                    withAnimation {
                        coordinator.parent.showAuthLoginView = true
                    }
                }
                
                if !(viewModel.journalViewModels?.isEmpty ?? true) {
                    withAnimation(.linear(duration: 0.3)) {
                        self.isAnimatedJournalView = true
                    }
                }
                
                #warning("TODO: Проверять на доступность события + что юзеру уже показывали сами экран")
                if !AppState.shared.moodWeenBannerShownFirstTime {
                    coordinator.parent.isShowingMoodWeenEventScreen = true
                    AppState.shared.moodWeenBannerShownFirstTime = true
                }

                withAnimation(Animation.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                    moodWeenShimmerAnimation.toggle()
                }
                
                
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true)) {
                    isScalingLeftMoodWeenAnimation.toggle()
                }
                
                getMoodCeck()
            }
            .onChange(of: viewModel.journalViewModels) { newValue in
                withAnimation(.linear(duration: 0.3)) {
                    self.isAnimatedJournalView = true
                }
            }
            
            if isSheetAboutMoodCheckPresent {
                moodcheckViewBlock()
            }
        }
        .onAppear {
            timeToEvent()
            startTimer()
        }
        .onDisappear {
            stopTimer()
            
            withAnimation {
                if isCompletedMoodCheck {
                    isCompletedMoodCheck.toggle()
                }
            }
        }
    }
    
    let calendar = Calendar.current
    
    func timeToEvent() {
        var components = DateComponents()
        components.year = 2023
        components.month = 11
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let targetDate = calendar.date(from: components) {
            // Получите текущую дату и время
            let currentDate = Date()
            
            // Вычислите разницу между текущей датой и желаемой датой
            let timeDifference = calendar.dateComponents([.second], from: currentDate, to: targetDate)
            
            if let secondsRemaining = timeDifference.second {
                if secondsRemaining > 0 {
                    remainingTime = TimeInterval(secondsRemaining)
                }
            }
        }
    }
    
    func startTimer() {
        isTimerRunning = true
        if isTimerRunning {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    stopTimer()
                    timer.invalidate()
                }
            }
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
    }
    
    func getMoodCeck() {
        viewModel.getMoodCheck {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.linear(duration: 0.4)) {
                    self.isAnimatedMoodCheck = true
                }
                
                if viewModel.moodCheckViewModel.isCheckStateUser && viewModel.moodCheckViewModel.isBreathActivity && viewModel.moodCheckViewModel.isCreateNewDiaryNote && !AppState.shared.isCompletedMoodCheck {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        confettiCannon = 1
                        withAnimation {
                            isCompletedMoodCheck.toggle()
                            AppState.shared.isCompletedMoodCheck = true
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            if AppState.shared.isCompletedMoodCheck {
                                isCompletedMoodCheck.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func diaryBlock() -> some View {
        Text("Эмоциональная поддержка")
            .foregroundColor(Colors.Primary.blue)
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
    private func moodcheckViewBlock() -> some View {
        VStack {}
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
            .background(.black.opacity(0.7))
            .transition(.opacity)
        
            .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                         switchablePositions: [.dynamicTop]) {
                VStack(spacing: 0) {
                    
                    Text("Эмоциональный чек-лист")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Colors.Primary.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 10)
                        .padding(.top, 5)
                    
                    Text("Эмоциональный чек-лист - это инструмент саморазвития, который помогает лучше понимать себя и управлять своими эмоциями, чтобы достичь более сбалансированной жизни\n")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.Primary.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 21)
                        .padding(.top, 20)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Ежедневно чек-лист обновляется и включает в себя 3 состовляющие - это состояние, дахание и дневник. Каждый новый день, вы будете видеть что чек-лист пустой и вы можете заполнить его\n")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.Primary.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 21)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                   
                    Text("Состояние - нужно отметить свое состояние, хотя бы 1 раз! Дыхание - вам нужно завершить практику минимум на 30%. Дневник - запщите свои мысли на текущий день, с помощью Дневника Благодарности\n")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.Primary.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 21)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Каждый из аспектов этого чек-листа сможет помочь лучше себя понимать и чувствовать. Конечно, как только вы завершите весь чек-лист на текущий день - мы покажем это и спрячем его")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.Primary.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 21)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                   
                    MTButton(buttonStyle: .fill, title: "Понятно") {
                        withAnimation {
                            bottomSheetPosition = .absolute(0)
                            isSheetAboutMoodCheckPresent.toggle()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation {
                                    self.bottomSheetPosition = .dynamicTop
                                    self.coordinator.parent.hideCustomTabBar = false
                                }
                            }
                        }
                    }
                    .frame(width: 230, height: 48, alignment: .top)
                    .padding(.top, 10)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 20)
            }
            .customBackground(
                Color.white
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .shadow(color: .white, radius: 0, x: 0, y: 0)
            )
            .enableTapToDismiss(true)
            .enableSwipeToDismiss(false)
            .enableContentDrag(false)
            .onDismiss {
                withAnimation {
                    bottomSheetPosition = .absolute(0)
                    isSheetAboutMoodCheckPresent.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            self.bottomSheetPosition = .dynamicTop
                            self.coordinator.parent.hideCustomTabBar = false
                        }
                    }
                }
            }
            .zIndex(9999999)
    }
    
    @ViewBuilder
    private func moodWeenEventBlock() -> some View {
        ZStack {
            Image(formattedTime == "" ? "ic-ms-moodWeenToday" : "ic-ms-moodWeenSoon")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(0.97)
            
            HStack(spacing: 0) {
                Image(formattedTime == "" ? "ic-ms-moodWeenToday" : "ic-ms-moodWeenSoon")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.white,Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    )
                    .rotationEffect(.init(degrees: 70))
                    .padding(20)
                    .offset(x: -250)
                    .offset(x: moodWeenShimmerAnimation ? 500 : 0)
            )
            
            HStack {
                VStack {
                    Text(formattedTime == "" ? "Сегодня" : "Событие")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("MoodWeen")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                
                HStack {
                    Image("ic-ms-moodWeenTime")
                        .resizable()
                        .frame(width: 15, height: 15)
                    
                    Text(formattedTime)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 6)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .opacity(formattedTime == "" ? 0 : 1)

            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: 83)
        .padding(.horizontal, 16)
        .rotation3DEffect(
            .degrees(isScalingLeftMoodWeenAnimation ? 1.1 : -1.1), axis: (x: 0.0, y: 0.2, z: 0.0))
        .shadow(color: Colors.TextColors.slateGray700.opacity(0.3),
                radius: 10, x: 0, y: 0)
    }
    
    @ViewBuilder
    private func reconfigureMainScreen() -> some View {
        Text("Ура конфиг работает!")
            .foregroundColor(Colors.Primary.blue)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
    }
    
    @ViewBuilder
    private func moodBreathView() -> some View {
        Text("Практики")
            .foregroundColor(Colors.Primary.blue)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
        
        createMoodBreathCover()
    }
    
    @ViewBuilder
    private func createEmotionalHeader() -> some View {
        
        ZStack {
            Image(getCurrentStateImageByTime())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 170.0, alignment: .leading)
        
            VStack {
                Text(getCurrentTimeDay())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 25)
                    .padding(.bottom, 5)
                
                Text(getTitleForSubTitleByTime())
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
        }
        .frame(maxWidth: .infinity, maxHeight: 170.0, alignment: .leading)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: Colors.TextColors.slateGray700.opacity(0.5),
                radius: 10, x: 0, y: 0)
    }
    
    @ViewBuilder
    private func createMoodCheck(isCompletedUserCheck: Bool, isCompletedBreathCheck: Bool, isCompletedDiaryCheck: Bool) -> some View {
        HStack() {
            VStack(spacing: 5) {
                Image(isCompletedUserCheck ? "ic-ms-moodCheck_selected" : "ic-ms-moodCheck_unselected")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.top, 5)
                
                Text("Состояние")
                    .foregroundColor(Colors.Primary.lavender500Purple)
                    .font(.system(size: 12, weight: .medium))
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(.top, -5)
                    .padding(.horizontal, 5)
            }
            
            VStack {}
                .frame(width: 35, height: 2, alignment: .center)
                .background(Colors.TextColors.athensGray300)
            
            VStack(spacing: 5) {
                Image(isCompletedBreathCheck ? "ic-ms-moodCheck_selected" : "ic-ms-moodCheck_unselected")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.top, 5)
                
                Text("Дыхание")
                    .foregroundColor(Colors.Primary.lavender500Purple)
                    .font(.system(size: 12, weight: .medium))
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(.top, -5)
                    .padding(.horizontal, 5)
            }
            
            VStack {}
                .frame(width: 35, height: 2, alignment: .center)
                .background(Colors.TextColors.athensGray300)

            VStack() {
                Image(isCompletedDiaryCheck ? "ic-ms-moodCheck_selected" : "ic-ms-moodCheck_unselected")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.top, 5)
                
                Text("Дневник")
                    .foregroundColor(Colors.Primary.lavender500Purple)
                    .font(.system(size: 12, weight: .medium))
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(.top, -5)
                    .padding(.horizontal, 5)
            }
           
        }
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .center)
        .background(.white)
        .compositingGroup()
        .cornerRadius(20)
        .padding(.horizontal, 35)
    }
    
    @ViewBuilder
    private func createJournalView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                
                if viewModel.journalViewModels?.count ?? 0 < 5 {
                    VStack {
                        Image("ic-ch-mood")
                            .resizable()
                            .frame(width: 50, height: 52)
                            .padding(.leading, 15)
                            .padding(.top, 20)
                       
                        Text("Создай новую запись")
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity, alignment: .center)
                            .foregroundColor(Colors.Primary.lavender500Purple)
                            .font(.system(size: 9, weight: .semibold))
                            .lineLimit(0)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 22)
                        
                    }
                    .frame(width: 116, height: 120)
                    .compositingGroup()
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: Colors.TextColors.mischka500,
                            radius: 2.0, x: 0.0, y: 0)
                    .padding(.leading, 20)
                    .onTapGesture {
                        if AppState.shared.isLogin ?? false {
                            if AppState.shared.userLimits == AppState.shared.maximumValueOfLimits {
                                coordinator.parent.showLimitsView = true
                            } else {
                                Services.metricsService.sendEventWith(eventName: .createEmotionNoteButtonFromTopBlock)
                                coordinator.openMoodCheckScreen()
                            }
                        } else {
                            withAnimation {
                                coordinator.parent.showAuthLoginView = true
                            }
                        }
                    }
                }
               
                ForEach(viewModel.journalViewModels?[0] ?? [], id: \.self) { item in
                    VStack {
                        Text(item.shortTime)
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.top, 14)
                        
                        Text(item.title)
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal, 5)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 4)
                       
                        Text(getStressTitle(item.stressRate))
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity, alignment: .bottom)
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .semibold))
                            .padding(.bottom, 22)
                        
                    }
                    .frame(width: 116, height: 120)
                    .compositingGroup()
                    .background(LinearGradient(colors: item.color, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    .shadow(color: Colors.TextColors.mischka500,
                            radius: 2.0, x: 0.0, y: 0)
                    .onTapGesture {
                        #warning("TODO: Нужна переработка экрана об эмоции, так как выглядит сыро и не вкусно")
//                        currentSelectedJournalPage = item
//                        showMoreDetailsAboutJournalPage.toggle()
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    private func createDiaryView() -> some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Image("dairyHelperCover")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .aspectRatio(1, contentMode: .fill)
                
                VStack {}
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(LinearGradient(colors: [Colors.Secondary.shamrock600Green,
                                                        Color(hex: "0B98C5")],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing).opacity(0.9))
                
                Text("Дневник\nблагодарности")
                    .foregroundColor(.white )
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: Colors.TextColors.mischka500,
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

                Text("Дыхательная\nпрактика 4-7-8")
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
        .shadow(color: Colors.TextColors.mischka500,
                radius: 3.0, x: 1.0, y: 0)
    }
    
    private func getStressTitle(_ stressRate: String) -> String {
        switch stressRate {
        case "fd3f28e0-273b-4a18-8aa8-56e85c9943c0": return "Низкий стресс"
        case "8b02d308-37fa-41de-bdd2-00303b976031": return "Средний стресс"
        case "42148e04-8ba7-468d-8ce6-4f25987bdbdf": return "Высокий стресс"
        default: return "Неизвестно"
        }
    }
    
    private func getColorByTime() -> [Color] {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return [Color(hex: "7392FC"),
                             Colors.Secondary.yourPinkRed400]
        case 12: return [Colors.Secondary.yourPinkRed400,
                         Colors.Secondary.peachOrange500Orange]
        case 13..<17: return [Colors.Secondary.yourPinkRed400,
                              Colors.Secondary.peachOrange500Orange]
        case 17..<22: return [Color(hex: "86E9C5"),
                              Color(hex: "0B98C5")]
        default: return  [Color(hex: "0B98C5"),
                          Color(hex: "11AADF"),
                          Color(hex: "7A42B6")]
        }
    }
    
    private func getCurrentTimeDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12: return NSLocalizedString("Доброе утро", comment: "Доброе утро")
        case 12: return NSLocalizedString("Добрый день", comment: "Добрый день")
        case 13..<17: return NSLocalizedString("Добрый день", comment: "Добрый день")
        case 17..<22: return NSLocalizedString("Добрый вечер", comment: "Добрый вечет")
        default: return NSLocalizedString("Доброй ночи", comment: "Доброй ночи")
        }
    }
    
    private func getCurrentStateImageByTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12: return "ic-ms-dt-morning"
        case 12: return "ic-ms-dt-morning"
        case 13..<17: return "ic-ms-dt-day"
        case 17..<22: return "ic-ms-dt-evening"
        default: return "ic-ms-dt-night"
        }
    }
    
    private func getTitleForSubTitleByTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12: return NSLocalizedString("Рады начать\nдень с тобой", comment: "Рады начать\nдень с тобой")
        case 12: return NSLocalizedString("Как приятно,\nчто ты здесь", comment: "Как приятно,\nчто ты здесь")
        case 13..<17: return NSLocalizedString("Как приятно,\nчто ты здесь", comment: "Как приятно,\nчто ты здесь")
        case 17..<22: return NSLocalizedString("Рады, что ты\nздесь со мной", comment: "Рады, что ты\nздесь со мной")
        default: return NSLocalizedString("Спасибо,\nчто ты есть", comment: "Спасибо,\nчто ты есть")
        }
    }
}
