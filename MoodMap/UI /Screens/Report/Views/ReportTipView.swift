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
        case goodActivitiesStress
        case badActivities
        case badActivitiesStress
        case commonEmotionState
        case commonEmotionStateStress
    }
    
    @State var text: String = ""
    @Binding var selectedText: String
    @Binding var isShowLoader: Bool
    
    @State var tipType: TipType = .goodActivities
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.white)
                .frame(maxWidth: UIScreen.main.bounds.width - 32, minHeight: 65, maxHeight: .infinity)
                .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                .overlay(
                    HStack {
                        if selectedText == "" {
                            if isShowLoader {
                                Text("Секунду..")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(Colors.Primary.blue) +
                                
                                Text(" уже ищем твои записи")
                                    .foregroundColor(getColorFor(tipType))
                                    .font(.system(size: 14, weight: .light))
                            } else {
                                Text("Начни свой путь отслеживания своего состояния, ")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(Colors.Primary.blue) +
                                
                                Text(" а мы соберем среднее значение и покажем тебе ☺️")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(getColorFor(tipType))
                            }
                            
                        } else {
                            Text(getTitleForTip(tipType).0)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(Colors.Primary.blue) +
                            
                            Text(getTitleForTip(tipType).1)
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
    
    private func getTitleForTip(_ state: TipType) -> (String, String) {
        switch state {
        case .badActivities: return (text, selectedText)
        case .badActivitiesStress: return (text, selectedText)
        case .commonEmotionState: return (text, selectedText)
        case .commonEmotionStateStress: return ("Твой уровень стресса на этой неделе в большинстве случаев ", selectedText)
        case .goodActivities: return (text, selectedText)
        case .goodActivitiesStress: return (text, selectedText)
        }
    }
    
    private func getColorFor(_ state: TipType) -> Color {
        switch state {
        case .goodActivities: return Colors.Secondary.shamrock600Green
        case .goodActivitiesStress: return Colors.Secondary.shamrock600Green
        case .badActivities: return Colors.Secondary.malibu600Blue
        case .badActivitiesStress: return Colors.Secondary.malibu600Blue
        case .commonEmotionStateStress:
            switch selectedText {
            case "Высокий": return Color(hex: "FFC8C8")
            case "Средний": return Color(hex: "B283E4")
            case "Низкий": return Color(hex: "86E9C5")
            default: return Colors.TextColors.slateGray700
            }
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
