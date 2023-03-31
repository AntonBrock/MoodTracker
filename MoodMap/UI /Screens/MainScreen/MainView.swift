//
//  MainView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct MainView: View {
    
    let container: DIContainer
    var animation: Namespace.ID
    
    private unowned let coordinator: MainViewCoordinator
    
    @State var typeSelectedIndex: Int = 0
    var typeTitles: [String] = ["Настроение", "Стресс"]
    
    init(
        container: DIContainer,
        animation: Namespace.ID,
        coordinator: MainViewCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
        self.animation = animation
    }
    
    var body: some View {
        ScrollView {
            VStack {
                createEmotionalHeader()
                    .padding(.top, 16)
                
                createChooseStateUser()
                    .padding(.top, 10)
                    .onTapGesture {
                        print("Show screen for add State loader")
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
                        print("Show screen diary")
                    }
                
                QuoteView()
                    .padding(.top, 10)
                
                
                Text("Статистика сегодня")
                    .foregroundColor(Colors.Primary.blue)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                SegmentedControlView(countOfItems: 3, segments: typeTitles,
                                     selectedIndex: $typeSelectedIndex,
                                     currentTab: typeTitles[0])
                .padding(.top, 16)
                .padding(.horizontal, 20)
                
                CircleEmotionChart(
                    emotionStateCounts: [10.0, 10.2],
//                        .compactMap({ Double($0.count) }) ?? [],
                    emotionNames: ["Asd", "asda"],
//                        .compactMap({ $0.text }) ?? [],
                    emotionColors: [.white, .blue],
//                        .compactMap({ Color(hex: $0.color) }) ?? [],
                    emotionTotal: 10
                )
                .padding(.top, 16)
                .padding(.horizontal, 10)
                
                DayilyCharts(viewModel: TimeDataViewModel(bestTime: "", worstTime: "", dayParts: nil))
                    .padding(.top, 16)
                    .padding(.horizontal, 10)
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
        
    
    @ViewBuilder
    private func createEmotionalHelperScroll() -> some View {
        let mockItems: [AnotherHelpsPreviewModel] = [
            AnotherHelpsPreviewModel(id: 0, title: "Дневник\nблагодарности", imagePreview: "dairyHelperCover"),
            AnotherHelpsPreviewModel(id: 1, title: "Будущее", imagePreview: "previewCover")
        ]
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(mockItems, id: \.self) { item in
                    ZStack {
                        Image("\(item.imagePreview)")
                        .resizable()
                        .frame(width: 240, height: 180)
                        .aspectRatio(1, contentMode: .fit)
                       
                        Text(item.title)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .foregroundColor(.white)
                            .font(Fonts.InterSemiBold16)
                            .lineSpacing(4.0)
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                        
                    }
                    .frame(width: 240, height: 180)
                    .cornerRadius(20)
                    .shadow(color: Colors.TextColors.mischka500, radius: 3.0, x: 1.0, y: 0)
                }
            }
        }.padding(.bottom, 48)
    }
}
