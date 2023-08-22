//
//  WhyRegistrationInfoView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 25.02.2023.
//

import SwiftUI

struct WhyRegistrationInfoView: View {
    
    var dismissScreenWithOpenAuthBlock: (() -> Void)
    var dismiss: (() -> Void)

    var body: some View {
        
        VStack {
            
            HStack {
                Image("leftBackBlackArror")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.leading, 18)
                    .onTapGesture {
                        withAnimation {
                            dismissScreenWithOpenAuthBlock()
                        }
                    }
                
                Text("Зачем нужна учетная запись?")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.leading, -42)
            }
            .frame(width: UIScreen.main.bounds.width, height: 48, alignment: .center)
            
            ZStack {
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        Image("registration-info-charts")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Точная аналитика")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Colors.Primary.blue)
                        Text("Так мы сможем предоставить вам подробную статистику по вашему состоянию за длительный период")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .multilineTextAlignment(.center)
                            .lineLimit(50)
                    }
                    .padding(.top, 45)
                    
                    VStack(spacing: 16) {
                        Image("registration-info-data")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("В целях безопасности")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Colors.Primary.blue)
                        Text("Вы сможете поставить пароль на свой аккаунт в приложении и восстановить его, если забудете")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .multilineTextAlignment(.center)
                            .lineLimit(50)
                    }
                    .padding(.top, 45)
                    
                    VStack(spacing: 16) {
                        Image("registration-info-info")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Бэкап и синхронизация")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Colors.Primary.blue)
                        Text("Вы можете открыть ваш аккаунт с любого устройства, и ваши записи никуда не пропадут")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .multilineTextAlignment(.center)
                            .lineLimit(50)
                    }
                    .padding(.top, 45)
                    
                    VStack(spacing: 16) {
                        Image("registration-info-main")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Персональная рассылка")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Colors.Primary.blue)
                        Text("Очень редко мы будем присылать вам на почту важные новости о приложении, персонализированные статьи и уведомления")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .multilineTextAlignment(.center)
                            .lineLimit(50)
                    }
                    .padding(.top, 45)
                    
                    VStack(spacing: 16) {
                        Image("registration-info-support")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Техническая поддержка")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Colors.Primary.blue)
                        Text("С помощью почты мы сможем связаться с вами и оперативно решить все волнующие вас вопросы")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .multilineTextAlignment(.center)
                            .lineLimit(50)
                    }
                    .padding(.top, 45)
                    .padding(.bottom, 120)
                }
                .padding(.horizontal, 16)
                
                MTButton(buttonStyle: .fill, title: "Зарегистрироваться") {
                    dismissScreenWithOpenAuthBlock()
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 28)
            }
        }
        .background(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
