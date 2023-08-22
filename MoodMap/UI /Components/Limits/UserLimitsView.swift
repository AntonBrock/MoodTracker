//
//  UserLimitsView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 28.05.2023.
//

import SwiftUI

struct UserLimitsView: View {
    
    var dismissAction: (() -> Void)
    
    var body: some View {
        VStack {
            Image("ch-ic-veryGood")
                .resizable()
                .frame(width: 156, height: 156, alignment: .center)
                .padding(.top, 84)
            
            Text("Вау!\n Выше тебя только небо")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 24)
            
            Text("Сейчас тебе доступно к созданию\nтолько 5 записей в день,\nвозвращайся завтра и продолжай в том же духе!")
                .font(.system(size: 18, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 24)
                .padding(.horizontal, 16)
            
            Spacer()
            
            MTButton(buttonStyle: .fill, title: "Хорошо") {
                dismissAction()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 84)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
