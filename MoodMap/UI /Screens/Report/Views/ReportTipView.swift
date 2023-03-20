//
//  ReportTipView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct ReportTipView: View {
    
//    enum ReportTipType {
//    case goodActivities
//    case badActivities
//    case `default`
//    }
    
//    @State var type: ReportTipType
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.white)
                .frame(maxWidth: UIScreen.main.bounds.width - 32, minHeight: 40, maxHeight: .infinity)
                .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                .overlay(
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .light))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Colors.Primary.blue)
                        .lineLimit(3)
                        .padding()
                )
                .padding(.top, 30)
        }
//        .onChange(of: type) { newValue in
//            switch newValue {
//            case .badActivities: text = "Активность, которая тебя радовала больше всего на этой неделе Работа"
//            case .goodActivities: text = "Активность, которая расстраивала больше всего на этой неделе Свидание"
//            case .default: text = ""
//            }
//        }
    }
}
