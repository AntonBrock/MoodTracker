//
//  CircleEmotionChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct EmotionCircleViewModel: Identifiable {
    let id = UUID().uuidString
    var name: String
    var value: String
    var color: Color
}

struct CircleEmotionChart: View {
        
    @Binding var emotionStateCounts: [Double]
    @Binding var emotionNames: [String]
    @Binding var emotionColors: [Color]
    @Binding var emotionTotal: Int
    @Binding var emotionCircleViewModel: [EmotionCircleViewModel]?
    
    @Binding var isLoading: Bool
    @Binding var dataIsEmpty: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 17)
            .frame(width: UIScreen.main.bounds.width - 32, height: 135, alignment: .center)
            .background(.white)
            .clipped()
            .overlay {
                if !emotionStateCounts.isEmpty {
                    PieChartView(
                        values: $emotionStateCounts,
                        total: $emotionTotal,
                        emotionsValuesByCategory: $emotionStateCounts,
                        colors: $emotionColors,
                        names: $emotionNames,
                        emotionCircleViewModel: $emotionCircleViewModel,
                        formatter: { value in String(format: "2f", value) }
                    )
                    .frame(width: UIScreen.main.bounds.width - 32, height: 135, alignment: .center)
                    .background(.white)
                    .cornerRadius(16)
                } else {
                    if isLoading {
                        VStack {
                            LottieView(name: "loader", loopMode: .loop)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 135, alignment: .center)
                        .background(.white)
                        .cornerRadius(16)
                    } else {
                        if dataIsEmpty {
                            VStack {
                                Text("Отметь свое состояние\nмы покажет стастистику по настроению")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(Colors.TextColors.fiord800)
                                    .font(.system(size: 12, weight: .medium))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: 135, alignment: .center)
                            .background(.white)
                            .cornerRadius(16)
                        }
                    }
                }
            }
            .shadow(color: Colors.Primary.lightGray.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}
