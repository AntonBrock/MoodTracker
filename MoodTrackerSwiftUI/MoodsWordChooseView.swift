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
        ["anguished face", "face with open mouth and cold sweat", "face with cold sweat", "disappointed but relieved face",
         "disappointed face", "dizzy face", "loudly crying face", "unamused face"],
        
        ["conused face", "sneezing face", "disappointed but relieved face", "disappointed face",
         "sleepy face", "expressionless face", "face with thermometer", "dizzy face"],
        
        ["relfieved face", "slightly smiling face", "face with medical mask", "astonished face",
         "hushed face", "thinking face", "smiling face with smiling eyes and handd covering mouth", "upside down face"],
        
        ["face savouring delicious food", "face with stuck out tongue and winking eye", "drooling face", "grinning face",
         "nerd face", "smiling face with open mouth", "white smiling face", "smiling face with heart shaped eyes"],
        
        ["face with party horn and party hat", "smiling face with horns", "smiling face with smiling eyes and three hearts", "smiling face with sunglassese",
         "smiling face with open mouth and tightly closed eyes", "smirking face", "grinning face with one large and one small eyea", "drooling face"],
        ["face with party horn and party hat", "smiling face with horns", "smiling face with smiling eyes and three hearts", "smiling face with sunglassese",
         "smiling face with open mouth and tightly closed eyes", "smirking face", "grinning face with one large and one small eyea", "drooling face"]
    ]
    
    var emotionsArrayTitle: [[String]] =
    [
        ["Лицо", "Лицо", "Лицо", "Лицо",
         "Лицо", "Лицо", "Лицо", "Лицо"],
        
        ["Лицо", "Лицо", "Лицо", "Лицо",
         "Лицо", "Лицо", "Лицо", "Лицо"],
        
        ["Лицо", "Лицо", "Лицо", "Лицо",
         "Лицо", "Лицо", "Лицо", "Лицо"],
        
        ["Лицо", "Лицо", "Лицо", "Лицо",
         "Лицо", "Лицо", "Лицо", "Лицо"],
        
        ["Лицо", "Лицо", "Лицо", "Лицо",
         "Лицо", "Лицо", "Лицо", "Лицо"],
        
        ["Лицо", "Лицо", "Лицо", "Лицо",
         "Лицо", "Лицо", "Лицо", "Лицо"]
    ]
    
    private let flexibleLayout = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)

    @ObservedObject var valueModel: SliderValueModele
//    @Binding var value: Double
    
    @State var selectedMoodId: String = "" // later change string to Int
    
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
                            .frame(width: 80, height: 90)
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
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Colors.Primary.blue)
                .frame(alignment: .center)
        }
        .onTapGesture {
            self.emotionDidChoosed(id: "\(emotion)")
        }
    }
    
    private func emotionDidChoosed(id: String) {
        self.selectedMoodId = id
        print(id)
    }
}
