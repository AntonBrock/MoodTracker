//
//  DayilyCharts.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct DayilyCharts: View {
    
    @Binding var viewModel: TimeDataViewModel
   
    var body: some View {
        HStack(spacing: 17) {
            
            if viewModel.dataIsEmpty {
                VStack {
                    createDaylyView("Утро", state: "Не нашли данных", colors: [Color(hex: "7392FC"), Color(hex: "FFC8C8")])
                    createDaylyView("Вечер", state: "Не нашли данных", colors: [Color(hex: "86E9C5"), Color(hex: "0B98C5")])
                        .padding(.top, 16)
                }
                
                VStack {
                    createDaylyView("День", state: "Не нашли данных", colors: [Color(hex: "FFC8C8"), Color(hex: "FFC794")])
                    createDaylyView("Ночь", state: "Не нашли данных", colors: [Color(hex: "0B98C5"), Color(hex: "7E46B9")])
                        .padding(.top, 16)
                }
            } else {
                
                VStack {
                    createDaylyView("Утро", state: viewModel.dayParts?.filter({ $0.time == "Утро"})[0].text ?? "Нет статистики", colors: [Color(hex: "7392FC"), Color(hex: "FFC8C8")])
                    createDaylyView("Вечер", state: viewModel.dayParts?.filter({ $0.time == "Вечер"})[0].text ?? "Нет статистики", colors: [Color(hex: "86E9C5"), Color(hex: "0B98C5")])
                        .padding(.top, 16)
                }
                
                VStack {
                    createDaylyView("День", state: viewModel.dayParts?.filter({ $0.time == "День"})[0].text ?? "Нет статистики", colors: [Color(hex: "FFC8C8"), Color(hex: "FFC794")])
                    createDaylyView("Ночь", state: viewModel.dayParts?.filter({ $0.time == "Ночь"})[0].text ?? "Нет статистики", colors: [Color(hex: "0B98C5"), Color(hex: "7E46B9")])
                        .padding(.top, 16)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func createDaylyView(_ title: String, state: String, colors: [Color]) -> some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: .init(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing // .init(x: 0.25, y: 0.5).init(x: 0.75, y: 0.5)
            ))
            .frame(width: 163, height: 58)
            .overlay {
                VStack {
                    HStack {
                        Text(title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 18)

                    Text(state)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.bottom, 25)
                        .fixedSize(horizontal: true, vertical: false)
                        .lineLimit(3)
                        .padding(.leading, -5)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 16)
            }
            .cornerRadius(18)
    }
}
