//
//  NewDiaryPageView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 02.04.2023.
//

import SwiftUI

struct NewDiaryPageView: View {
    
    var dismiss: (() -> Void)
    var saveNewDiaryPage: ((_ text: String) -> Void)
    
    var body: some View {
        
        headerView()
            .frame(height: 240)
         
        ActivitiesTextViewBlock(subPlaceholder: "Запишите, за что испытываете чувство благодарности",
                                type: .diary, saveDiaryText: { text in
            self.saveNewDiaryPage(text)
            self.dismiss()
        })
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
        
        Spacer()

    }
    
    @ViewBuilder
    private func headerView() -> some View {
        ZStack {
            VStack {}
                .frame(maxWidth: .infinity, minHeight: 240)
                .background(GradientRoundedCornersView(gradient: [Color(hex: "53B6BE"), Color(hex: "479096")],
                                                       tl: 0, tr: 0, bl: 10, br: 10).opacity(0.95))
                
            VStack {
                Text("За что\nты благодаришь?")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                
                Text("Благодарность ‒\nуниверсальный язык счастья")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.bottom, 36)
            .padding(.leading, 24)
        }
        
    }
}
