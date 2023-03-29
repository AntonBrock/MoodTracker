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
    }
    
    @State var text: String = ""
    @State var selectedText: String = ""
    
    @State var tipType: TipType = .goodActivities
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.white)
                .frame(maxWidth: UIScreen.main.bounds.width - 32, minHeight: 40, maxHeight: .infinity)
                .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                .overlay(
                    HStack {
                        Text(text)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Colors.Primary.blue) +
                        
                        Text(selectedText)
                            .foregroundColor(getColorFor(tipType))
                            .font(.system(size: 14, weight: .light))
                    }
                    .multilineTextAlignment(.center)
                )
                .padding(.top, 30)
        }
    }
    
    private func getColorFor(_ state: TipType) -> Color {
        switch state {
        case .goodActivities: return Colors.Secondary.shamrock600Green
        case .badActivities: return Colors.Secondary.malibu600Blue
        }
    }
}
