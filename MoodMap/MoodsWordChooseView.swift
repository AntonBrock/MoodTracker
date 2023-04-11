//
//  MoodsWordChooseView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 16.09.2022.
//


import SwiftUI

struct MoodsWordChooseView: View {
    
    var emotionViewModel: [[EmotionsViewModel]] = []
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
                let emotions = emotionViewModel[Int(valueModel.value.rounded() / 10.0)]
                
                if !emotions.isEmpty {
                    ForEach(1...emotions.count, id: \.self) { item in
                        ZStack {
                            MoodsWordChooseViewBlock(emotionId: emotions[item - 1].id,
                                                     emotion: emotions[item - 1].image,
                                                     emotionTitle: emotions[item - 1].text,
                                                     selectedMoodId: $selectedMoodId)
                            .frame(width: 90, height: 95)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: Colors.TextColors.mystic400, radius: 6.0, x: 0, y: 0)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedMoodId == emotions[item - 1].id ?
                                            Colors.Primary.royalPurple600Purple :
                                            .white, lineWidth: 1)
                            }
                            .padding(.top, 16)
                        }
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
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Colors.Primary.blue)
                .frame(alignment: .center)
        }
        .onTapGesture {
            self.emotionDidChoosed(id: emotionId)
        }
    }
    
    private func emotionDidChoosed(id: String) {
        self.selectedMoodId = id
    }
}
