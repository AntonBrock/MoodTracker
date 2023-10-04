//
//  ATTView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 13.04.2023.
//

import SwiftUI
import AppTrackingTransparency

struct ATTView: View {
    
    var closeAction: (() -> Void)
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Text("У тебя iOS 14.5 или вышe,\nа значит мы должны получить\nсогласие на использование твоих данных")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 44)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                .padding(.trailing, 24)
            
            HStack {
                Image("ic-lock")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Мы их обезличиваем\nи используем для улучшения отчета")
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
                Image("ic-ad")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Так мы вкладываем больше ресурсов\nв дальнейшее развитие приложения")
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
                Image("ic-notSee")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Храним данные надежно\nи никуда не передаем")
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
                Text("Разрешить их использовать можно\nна следующем экране")
                    .foregroundColor(Colors.Primary.lightGray)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
                
                MTButton(buttonStyle: .fill, title: "Продолжить") {
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        switch status {
                        case .authorized:
                            // Tracking authorization dialog was shown
                            // and we are authorized
                            print("Authorized")
                            self.dismiss.callAsFunction()
                            self.closeAction()
                        case .denied:
                            // Tracking authorization dialog was
                            // shown and permission is denied
                            print("Denied")
                            self.dismiss.callAsFunction()
                            self.closeAction()
                        case .notDetermined:
                            // Tracking authorization dialog has not been shown
                            print("Not Determined")
                        case .restricted:
                            print("Restricted")
                        @unknown default:
                            print("Unknown")
                        }
                    })
                }
                .padding(.horizontal, 24)
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 41)
        }
    }
}
