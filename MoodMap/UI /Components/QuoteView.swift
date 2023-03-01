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
        
        ZStack {
            Image("quoteBackground")
            .resizable()
            .scaledToFit()
            
            VStack(alignment: .center, spacing: 16) {
                Text(quote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.TextColors.cello900)
                    .font(Fonts.InterRegular16)
                    .lineSpacing(4.0)
                    .padding(.horizontal, 16)
                
                Button("Еще поддержки") {
                    print("More helps")
                }
                    .frame(width: 160, height: 32)
                    .background(.white)
                    .tint(Colors.Primary.lavender500Purple)
                    .multilineTextAlignment(.center)
                    .cornerRadius(32 / 2)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 200)
        .cornerRadius(20)
        .shadow(color: Colors.TextColors.mischka500, radius: 3.0, x: 1.0, y: 0)
    }
}
