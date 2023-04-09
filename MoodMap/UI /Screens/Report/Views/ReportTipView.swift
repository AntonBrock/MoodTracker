//
//  ReportTipView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct ReportTipView: View {
    
    enum TipType {
        case goodActivities
        case badActivities
        case commonEmotionState
    }
    
    @State var text: String = ""
    @Binding var selectedText: String
    
    @State var tipType: TipType = .goodActivities
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.white)
                .frame(maxWidth: UIScreen.main.bounds.width - 32, minHeight: 40, maxHeight: .infinity)
                .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                .overlay(
                    HStack {
                        if selectedText == "" {
                            Text("Мы не нашли за выбранный период твоих данных")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(Colors.Primary.blue) +
                            
                            Text(" начинай следить за своим состоянием")
                                .foregroundColor(getColorFor(tipType))
                                .font(.system(size: 14, weight: .light))
                        } else {
                            Text(text)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(Colors.Primary.blue) +
                            
                            Text(selectedText)
                                .foregroundColor(getColorFor(tipType))
                                .font(.system(size: 14, weight: .light))
                        }
                     
                    }
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .padding()
                )
                .padding(.top, 30)
        }
    }
    
    private func getColorFor(_ state: TipType) -> Color {
        switch state {
        case .goodActivities: return Colors.Secondary.shamrock600Green
        case .badActivities: return Colors.Secondary.malibu600Blue
        case .commonEmotionState:
            switch selectedText {
            case "Oчень плохо": return Color(hex: "F5DADA")
            case "Плохо": return Color(hex: "B9C8FD")
            case "Нормально": return Color(hex: "B283E4")
            case "Хорошо": return Color(hex: "86E9C5")
            case "Очень хорошо": return Color(hex: "FFC794")
            default: return Colors.TextColors.slateGray700
            }
        }
    }
}
