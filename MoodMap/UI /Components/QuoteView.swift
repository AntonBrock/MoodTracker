//
//  QuoteView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 26.09.2022.
//

import SwiftUI

struct QuoteView: View {
        
    @Binding var quote: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Image(getBackgroundIconByTime())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                Text("\(quote)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .lineSpacing(4.0)
                    .padding(.horizontal, 12)
                    .shadow(color: Colors.TextColors.cadetBlue600.opacity(0.5),
                            radius: 1.0, x: 1.0, y: 1.0)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .shadow(color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mischka500,
                radius: 3.0, x: 1.0, y: 0)
    }
    
    private func getBackgroundIconByTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "ic-ms-q-morning"
        case 12: return "ic-ms-q-day"
        case 13..<17: return "ic-ms-q-day"
        case 17..<22: return "ic-ms-q-evening"
        default: return "ic-ms-q-night"
        }
    }
}
