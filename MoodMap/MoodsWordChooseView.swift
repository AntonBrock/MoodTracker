//
//  MoodsWordChooseView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 16.09.2022.
//


import SwiftUI

struct MoodsWordChooseView: View {
    
    var emotionsArrayImageName: [[String]] =
    [
        ["em-vb-dizzyFace", "em-vb-unStrongFace", "em-vb-perseveringFace", "em-vb-spiralEyesFace",
         "em-vb-angryFace", "em-vb-cryingFace", "em-vb-fearfulFace", "em-vb-screamingInFearFace"],
        
        ["em-b-unamusedFace", "em-b-hotFace", "em-b-confoundedFace", "em-b-anxiousFace",
         "em-b-poutingFace", "em-b-cryingFace", "em-b-worriedFace", "em-b-grimacingFace"],
        
        ["em-f-diagonalMouthFace", "em-f-sleepingFace", "em-f-exhalingFace", "em-f-withoutMouthFace",
         "em-f-wearyFace", "em-f-flushedFace", "em-f-expressionlessFace", "em-f-smilingFaceWithSmilingEyes"],
        
        ["em-g-squintingWithTongueFace", "em-g-beamingWithSmilingEyesFace", "em-g-winkingWithTongueFace", "em-g-kissingFace",
         "em-g-smilingWithHeartsFace", "em-g-kissingWithSmilingEyesFace", "em-g-relievedFace", "em-g-blowingAKissFace"],
        
        ["em-vg-nerdFace", "em-vg-starStruckFace", "em-vg-happyWithEnlargedEyesFace", "em-vg-smilingWithHaloFace",
         "em-vg-smilingWithHeartEyesFace", "em-vg-kissingWithClosedEyesFace", "em-vg-smilingWithSunglassesFace", "em-vg-withTongueFace"]
        
    ]
    
    var emotionsArrayTitle: [[String]] =
    [
        ["Апатия", "Бессилие", "Тоска", "Потерянонсть",
         "Агрессия", "Отчаяние", "Тревожность", "Паника"],
        
        ["Безразличие", "Переутомление", "Подавленость", "Растерянность",
         "Недовольство", "Печаль", "Обида", "Беспокойство"],
        
        ["Скука", "Усталость", "Лень", "Неуверенность",
         "Раздражение", "Смущение", "Сомнение", "Спокойствие"],
        
        ["Веселье", "Энергичность", "Бодрость", "Уверенность",
         "Умиротворение", "Нежность", "Доверие", "Влюбленность"],
        
        ["Интерес", "Активность", "Восторг", "Покой",
         "Любовь", "Забота", "Гордость", "Эйфория"]
    ]
    
    private let flexibleLayout = Array(repeating: GridItem(.flexible(),
                                                           spacing: 35), count: 4)

    @ObservedObject var valueModel: SliderValueModele
    @State var selectedMoodId: String = "" // later change string to Int
    
    var setChoosedEmotion: ((String) -> Void)
    
    var body: some View {
        VStack {
            Text("Какие эмоции описывают твои чувства лучше всего?")
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Colors.Primary.blue)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
                .fixedSize(horizontal: false, vertical: true)
            
            LazyVGrid(columns: flexibleLayout) {
                let emotions = emotionsArrayImageName[Int(valueModel.value.rounded() / 10.0)]
                let emotionTitle = emotionsArrayTitle[Int(valueModel.value.rounded() / 10.0)]

                ForEach(1...emotions.count, id: \.self) { item in
                    ZStack {
                        MoodsWordChooseViewBlock(emotion: emotions[item - 1],
                                                 emotionTitle: emotionTitle[item - 1],
                                                 selectedMoodId: $selectedMoodId)
                            .frame(width: 90, height: 95)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: Colors.TextColors.mystic400, radius: 6.0, x: 0, y: 0)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedMoodId == emotions[item - 1] ?
                                            Colors.Primary.royalPurple600Purple :
                                            .white, lineWidth: 1)
                            }
                            .padding(.top, 16)
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 32, trailing: 16))
        }
        .onChange(of: selectedMoodId) { newValue in
            setChoosedEmotion(newValue)
        }
    }
}

struct MoodsWordChooseViewBlock: View {
    
    var emotion: String
    var emotionTitle: String
    
    @Binding var selectedMoodId: String
    
    var body: some View {
        
        VStack(spacing: 7) {
            Image("\(emotion)")
                .resizable()
                .frame(width: 38, height: 38)
            Text("\(emotionTitle)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Colors.Primary.blue)
                .frame(alignment: .center)
        }
        .onTapGesture {
            self.emotionDidChoosed(id: "\(emotion)")
        }
    }
    
    private func emotionDidChoosed(id: String) {
        self.selectedMoodId = id
//        print(id)
    }
}
