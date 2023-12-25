//
//  DetailsDiaryPage.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 05.04.2023.
//

import SwiftUI

struct DetailsDiaryPage: View {
    
    var dismiss: (() -> Void)
    var diaryPage: DiaryViewModel?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                headerView(diaryPage?.createdAt ?? "")
                    .frame(height: 240)
                 
                ScrollView {
                    Text(diaryPage?.message ?? "")
                        .foregroundColor(colorScheme == .dark ? Colors.Primary.lightGray : Colors.Primary.blue)
                        .font(.system(size: 20, weight: .medium))
                        .lineLimit(9999999)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func headerView(_ timeCreated: String) -> some View {
        ZStack {
            VStack {}
                .frame(maxWidth: .infinity, minHeight: 240)
                .background(GradientRoundedCornersView(gradient: [Color(hex: "53B6BE"), Color(hex: "479096")],
                                                       tl: 0, tr: 0, bl: 10, br: 10).opacity(0.95))
                
            VStack {
                Button {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                        dismiss()
                    }
                } label: {
                    Image("ic-navbar-backIcon-white")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                
                Spacer()
                
                Text(timeCreated)
                    .foregroundColor(Color(hex: "C9F0E2"))
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                
                Text("Дневник\nблагодарности")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.bottom, 36)
            .padding(.leading, 24)
        }
        
    }
}
