//
//  DayilyCharts.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct DayilyCharts: View {
   
    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: .init(colors: [Color(hex: "7392FC"),
                                         Color(hex: "FFC8C8")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing // .init(x: 0.25, y: 0.5).init(x: 0.75, y: 0.5)
            ))
            .frame(width: 163, height: 58)
            .overlay {
                VStack {
                    HStack {
                        Text("Утро")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

                    Text("Очень плохо")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal, 16)
            }
            .cornerRadius(16)
    }
}
