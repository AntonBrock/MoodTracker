//
//  QuoteView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 26.09.2022.
//

import SwiftUI

struct QuoteView: View {
    
    var quote: String = "Это нормально ‒ испытывать плохие эмоции. Это не делает тебя плохим человеком."
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(quote)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .light))
                .lineSpacing(4.0)
                .padding(.horizontal, 16)
                .shadow(color: Colors.TextColors.cadetBlue600.opacity(0.5),
                        radius: 1.0, x: 1.0, y: 1.0)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(LinearGradient(colors: getColorByTime(), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: Colors.TextColors.mischka500,
                radius: 3.0, x: 1.0, y: 0)
    }
    
    private func getColorByTime() -> [Color] {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return [Colors.Secondary.malibu600Blue, Colors.Secondary.yourPinkRed400]
        case 12: return [Colors.Secondary.yourPinkRed400, Colors.Secondary.peachOrange500Orange]
        case 13..<17: return [Colors.Secondary.yourPinkRed400, Colors.Secondary.peachOrange500Orange]
        case 17..<22: return [Colors.Secondary.riptide500Green, Color(hex: "0B98C5")]
        default: return  [Color(hex: "0B98C5"), Color(hex: "7E46B9")]
        }
    }
}
