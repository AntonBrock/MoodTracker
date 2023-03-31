//
//  CircleEmotionChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct CircleEmotionChart: View {
        
    @State var emotionStateCounts: [Double] = []
    @State var emotionNames: [String] = []
    @State var emotionColors: [Color] = []
    @State var emotionTotal: Int = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 17)
            .frame(width: UIScreen.main.bounds.width - 32, height: 135, alignment: .center)
            .background(.white)
            .clipped()
            .overlay {
                if !emotionStateCounts.isEmpty {
                    PieChartView(
                        total: emotionTotal,
                        emotionsValuesByCategory: emotionStateCounts,
                        values: emotionStateCounts,
                        names: emotionNames, //["Очень хорошо", "Хорошо", "Нормально", "Плохо", "Очень плохо"]
                        formatter: { value in String(format: "2f", value) },
                        colors: emotionColors,
                        backgroundColor: .white
                    )
                    .frame(width: UIScreen.main.bounds.width - 32, height: 135, alignment: .center)
                    .cornerRadius(16)
                }
            }
            .shadow(color: Colors.Primary.lightGray.opacity(0.2), radius: 5, x: 0, y: 0)
//            .onAppear {
//                emotionNames = emotionViewModel?.state.compactMap({ $0.text }) ?? []
//                emotionStateCounts = emotionViewModel?.state.compactMap({ Double($0.count) }) ?? []
//                emotionColors = emotionViewModel?.state.compactMap({ Color(hex: $0.color) }) ?? []
//            }
    }
}
