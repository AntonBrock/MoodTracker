//
//  MoodsWordChooseView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 16.09.2022.
//


import SwiftUI

struct MoodsWordChooseView: View {
    
    @Environment(\.colorScheme) var colorScheme

    var emotionViewModel: [[EmotionsViewModel]] = []
    private let flexibleLayout = Array(repeating: GridItem(.flexible(), spacing: 35), count: 4)

    @ObservedObject var valueModel: SliderValueModele
    @State var selectedMoodId: String = ""
    
    var setChoosedEmotion: ((String) -> Void)
    
    var leftAction: (() -> Void)
    var rightAction: (() -> Void)
    
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Какая эмоция лучше всего описывает твои чувства сейчас?")
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? Colors.Primary.lightGray : Colors.Primary.blue)
                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
                    .fixedSize(horizontal: false, vertical: true)
                
                LazyVGrid(columns: flexibleLayout) {
                    let emotions = emotionViewModel[Int(valueModel.value.rounded() / 10.0)]
                    
                    if !emotions.isEmpty {
                        ForEach(1...emotions.count, id: \.self) { item in
                            ZStack {
                                MoodsWordChooseViewBlock(
                                    emotionId: emotions[item - 1].id,
                                    emotion: emotions[item - 1].image,
                                    emotionTitle: emotions[item - 1].text,
                                    selectedMoodId: $selectedMoodId
                                )
                                .frame(width: 85, height: 90)
                                .background(colorScheme == .dark ? Colors.Primary.comet : .white)
                                .cornerRadius(10)
                                .shadow(color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mystic400,
                                        radius: 6.0, x: 0, y: 0)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedMoodId == emotions[item - 1].id ?
                                                colorScheme == .dark ? Colors.Primary.lavender500Purple : Colors.Primary.royalPurple600Purple :
                                                .white, lineWidth: 1)
                                }
                                .padding(.top, 16)
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 32, trailing: 16))
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            leftAction()
                        }
                        
                        if value.translation.width > 0 {
                            rightAction()
                        }
                    })
                )
            }
            .onChange(of: selectedMoodId) { newValue in
                setChoosedEmotion(newValue)
            }
        }
    }
}

struct MoodsWordChooseViewBlock: View {
    @Environment(\.colorScheme) var colorScheme

    var emotionId: String
    var emotion: String
    var emotionTitle: String
    
    @Binding var selectedMoodId: String
    
    var body: some View {
        
        VStack(spacing: 7) {
            Image("\(emotion)")
                .resizable()
                .frame(width: 38, height: 38)
            Text("\(emotionTitle)")
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .foregroundColor(colorScheme == .dark ? .white : Colors.Primary.blue)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
        .onTapGesture {
            self.emotionDidChoosed(id: emotionId)
        }
    }
    
    private func emotionDidChoosed(id: String) {
        self.selectedMoodId = id
    }
}
