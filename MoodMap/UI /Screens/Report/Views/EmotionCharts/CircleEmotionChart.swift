//
//  CircleEmotionChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct CircleEmotionChart: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 17)
            .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
            .clipped()
            .overlay {
                PieChartView(
                    values: [10, 20, 60, 0, 10],
                    names: ["Очень хорошо", "Хорошо", "Нормально", "Плохо", "Очень плохо"],
                    formatter: {value in String(format: "$%.2f", value)},
                    colors: [Color(hex: "FFC794"), Color(hex: "86E9C5"), Color(hex: "B283E4"), Color(hex: "B9C8FD"), Color(hex: "F5DADA")],
                    backgroundColor: .white
                )
                .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
                .cornerRadius(16)
            }
            .shadow(color: Colors.Primary.lightGray.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}
