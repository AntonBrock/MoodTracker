//
//  PushNotificationView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 13.04.2023.
//

import SwiftUI
import UserNotifications
import OneSignal

struct PushNotificationView: View {
    
    var closeAction: (() -> Void)
    
    var body: some View {
        
        VStack {
            Text("А теперь включим\npush-уведомления?\nВот почему:")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 44)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
            
            HStack {
                Image("ic-report")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Удобно следить\nза прогрессом твоего настроения")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Colors.Primary.blue)
                    .padding(.leading, 16)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 24)
            .padding(.top, 30)
            
            HStack {
                Image("ic-bell")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Не пропустишь время\nдля новой записи состояния")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Colors.Primary.blue)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 16)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 24)
            .padding(.top, 16)
            
            HStack {
                Image("ic-flag")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Без спама,\nтолько важные напоминания")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Colors.Primary.blue)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 24)
            .padding(.top, 16)
            
            Spacer()
            
            VStack {
                Text("Разрешить присылать пуши\nможно на следующем экране")
                    .foregroundColor(Colors.Primary.lightGray)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
                
                MTButton(buttonStyle: .fill, title: "Продолжить") {
                    // Проверка были ли включены пуши у юезра, если не было запроса - спросить
                    
                    // OneSignal initialization
                    OneSignal.initWithLaunchOptions()
                    OneSignal.setAppId("da77481a-ba27-43f6-8771-37227b99d2e3")
                    
                    OneSignal.promptForPushNotifications(userResponse: { accepted in
                        // Если пуши включают - задаем id для бэка
                        guard let userID = AppState.shared.userID else { return }
                        OneSignal.setExternalUserId(userID)
                        
                        AppState.shared.userPushNotification = true
                        
                        closeAction()
                    })
                }
                .padding(.horizontal, 24)
                .padding(.top, 5)
                
                Button {
                    AppState.shared.rememberPushNotificationDate = Date()
                    closeAction()
                } label: {
                    Text("Не сейчас")
                        .foregroundColor(Colors.Primary.lavender500Purple)
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 41)
        }
    }
}
