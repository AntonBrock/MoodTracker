//
//  MainView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: ViewModel

    let container: DIContainer
    var animation: Namespace.ID

    private unowned let coordinator: MainViewCoordinator
    
    @State var typeSelectedIndex: Int = 0
    
    @State var isAnimated: Bool = false
    @State var isAnimatedJournalView: Bool = false
    
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
        ScrollView {
            VStack {
                if isAnimated {
                    createEmotionalHeader()
                        .padding(.top, 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                if !(viewModel.journalViewModels?.isEmpty ?? true) {
                    if isAnimatedJournalView {
                        createJournalView()
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                
                createChooseStateUser()
                    .padding(.top, 10)
                    .onTapGesture {
                        coordinator.openMoodCheckScreen()
                    }
                
                
                Text("Эмоциональная поддержка")
                    .foregroundColor(Colors.Primary.blue)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                createDiaryView()
                    .padding(.top, 10)
                    .onTapGesture {
                        coordinator.openDiary()
                    }
                
                QuoteView()
                    .padding(.top, 10)
                
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
                    dataIsEmpty: $viewModel.emotionCountData.dataIsEmpty
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
            }
        }
        .onAppear {
            viewModel.setupViewer(self)
            
            withAnimation(.linear(duration: 0.3)) {
                self.isAnimated = true
            }
            
            if !(viewModel.journalViewModels?.isEmpty ?? true) {
                withAnimation(.linear(duration: 0.3)) {
                    self.isAnimatedJournalView = true
                }
            }
        }
        .onChange(of: viewModel.journalViewModels) { newValue in
            withAnimation(.linear(duration: 0.3)) {
                self.isAnimatedJournalView = true
            }
        }
    }
    
    @ViewBuilder
    private func createChooseStateUser() -> some View {
        HStack {
            Image("ic-ch-mood")
                .resizable()
                .frame(width: 50, height: 52)
                .padding(.leading, 20)
                .padding(.top, 10)
            
            VStack {
                Text("Как ты себя чувствуешь?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.Primary.blue)
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Тебя беспокоит что-то? Можешь поделиться?")
                    .foregroundColor(Colors.Primary.lavender500Purple)
                    .font(.system(size: 11, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: Colors.Primary.lavender500Purple,
                radius: 4.0, x: 1.0, y: 1.0)
        
    }
    
    @ViewBuilder
    private func createEmotionalHeader() -> some View {
        HStack {
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
            
            HStack {
                Image(getCurrentStateImageByTime())
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 158, height: 158)
            }
            .frame(alignment: .bottomTrailing)
            .padding(.trailing, -20)
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: 140.0, alignment: .leading)
        .background(LinearGradient(colors: getColorByTime(), startPoint: .topLeading, endPoint: .bottomTrailing))
        .compositingGroup()
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: Colors.TextColors.mystic400,
                radius: 10, x: 0, y: 0)
    }
    
    @ViewBuilder
    private func createJournalView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                VStack {
                    Image("ic-jn-openJournal")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.top, 10)
                   
                    Text("Посмотреть журнал")
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity, alignment: .center)
                        .foregroundColor(Colors.Primary.lavender500Purple)
                        .font(.system(size: 10, weight: .medium))
                        .padding(.top, 21)
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
                    print("open journal")
                }
                
                // Всегда берем 1 элемент, так как нужно показать инфу за текущий день
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
                        print("Open choosed page in journal ")
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
        case 6..<12: return [Colors.Secondary.malibu600Blue, Colors.Secondary.yourPinkRed400]
        case 12: return [Colors.Secondary.yourPinkRed400, Colors.Secondary.peachOrange500Orange]
        case 13..<17: return [Colors.Secondary.yourPinkRed400, Colors.Secondary.peachOrange500Orange]
        case 17..<22: return [Colors.Secondary.riptide500Green, Color(hex: "0B98C5")]
        default: return  [Color(hex: "0B98C5"), Color(hex: "7E46B9")]
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
        case 6..<12: return "ch-ic-veryGood"
        case 12: return "ch-ic-veryGood"
        case 13..<17: return "ch-ic-veryGood"
        case 17..<22: return "ch-ic-veryGood"
        default: return "ch-ic-fine"
        }
    }
    
    private func getTitleForSubTitleByTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12: return NSLocalizedString("Рад, начать\nдень с тобой", comment: "Рад, начать\nдень с тобой")
        case 12: return NSLocalizedString("Как приятно,\nчто ты здесь", comment: "Как приятно,\nчто ты здесь")
        case 13..<17: return NSLocalizedString("Как приятно,\nчто ты здесь", comment: "Как приятно,\nчто ты здесь")
        case 17..<22: return NSLocalizedString("Рад, что ты\nздесь со мной", comment: "Рад, что ты\nздесь со мной")
        default: return NSLocalizedString("Спасибо,\nчто ты есть", comment: "Спасибо,\nчто ты есть")
        }
    }
}
