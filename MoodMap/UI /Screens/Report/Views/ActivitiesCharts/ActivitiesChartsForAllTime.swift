//
//  ActivitiesChartsForAllTime.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.03.2023.
//

import SwiftUI

struct ActivitiesChartsForAllTime: View {
    
    enum ActivityState {
        case possitive
        case nigotive
    }
    
    enum StressState {
        case possitive
        case nigotive
    }
    
    @State var activityState: ActivityState = .possitive
    
    var body: some View {
        VStack {
            Text("Февраль 2023")
                .foregroundColor(Colors.Primary.blue)
                .font(.system(size: 12, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack{
                HStack {
                    Image("ac-ic-date")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "ECEDF0"), lineWidth: 1)
                                .frame(width: 50, height: 50)
                        )
                    
                    VStack {
                        Text("Активность")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Colors.Primary.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                        
                        HStack(spacing: 12) {
                            createStateForActivity(.possitive)
                            createStateForStress(.nigotive)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 15)
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Text("7")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Colors.Secondary.shamrock600Green)
                                .frame(width: 24, height: 24)
                        )
                        .padding(.trailing, 8)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 16)
            .background(
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Colors.TextColors.cadetBlue600.opacity(0.3), radius: 3)
            )
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .padding(.top, 26)
    }
    
    @ViewBuilder
    private func createStateForActivity(_ state: ActivityState) -> some View {
        HStack {
            Text(state == .possitive ? "Вдохновляет" : "Изматывает")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(state == .possitive ? Colors.Secondary.shamrock600Green : Colors.Secondary.malibu600Blue)
            Image(state == .possitive ? "rp-ic-state-possitive" : "rp-ic-state-nigotive")
                .resizable()
                .frame(width: 7, height: 5, alignment: .center)
                .padding(.leading, 5)
        }
    }
    
    @ViewBuilder
    private func createStateForStress(_ state: StressState) -> some View {
        HStack {
            Text(state == .possitive ? "Успокаевает" : "Тревожит")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(state == .possitive ? Colors.Secondary.shamrock600Green : Colors.Secondary.malibu600Blue)
            Image(state == .possitive ? "rp-ic-state-possitive" : "rp-ic-state-nigotive")
                .resizable()
                .frame(width: 7, height: 5, alignment: .center)
                .padding(.leading, 5)
        }
    }
}
