//
//  PersonalCabinetView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct PersonalCabinetView: View {
    
    @State var isPushNotificationOn: Bool = false
    private unowned let coordinator: PersonalCabinetViewCoordinator
    
    init(
        coordinator: PersonalCabinetViewCoordinator,
        showAuthMethodView: Bool = false
    ){
        self.coordinator = coordinator
    }

    var body: some View {
        
        ScrollView {
            
            CreateLoginView("", isLogin: false)
                .background(.white)
                .padding(.top, 16)
                .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                Text("ОСНОВНОЕ")
                    .frame(width: UIScreen.main.bounds.width - 32, height: 56, alignment: .bottomLeading)
                    .foregroundColor(Colors.Primary.lightGray)
                    .font(.system(size: 12))
                
                VStack {
                    Toggle(isOn: $isPushNotificationOn) {
                        Text("Напоминания")
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                    
                    createArrowBlock("Создание пароля")
                        .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                        .padding(.trailing, 5)
                        .onTapGesture {
                            coordinator.openLoginView()
                        }
                    
                }
                .padding(.horizontal, 24)
                .background(.white)
            }
            .background(Colors.Primary.lightWhite)
            
            VStack(spacing: 12) {
                Text("ДОПОЛНИТЕЛЬНОЕ")
                    .frame(width: UIScreen.main.bounds.width - 32, height: 56, alignment: .bottomLeading)
                    .foregroundColor(Colors.Primary.lightGray)
                    .font(.system(size: 12))
                
                
                VStack {
                    createArrowBlock("Поддержка")
                        .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                        .padding(.trailing, 5)
                    
                    createArrowBlock("Пользовательское соглашение")
                        .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                        .padding(.trailing, 5)
                    
                }
                .padding(.horizontal, 24)
                .background(.white)
            }
            .background(Colors.Primary.lightWhite)
        }
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    private func CreateLoginView(_ title: String, isLogin: Bool) -> some View {
        HStack {
            VStack {
                VStack(spacing: 4) {
                    Text("Привет, ")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Colors.Primary.lightGray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(isLogin ? "Name_User" : "Вы не вошли в аккаунт")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isLogin ? Colors.Primary.lavender500Purple : .white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: -24, leading: 16, bottom: 0, trailing: 0))
                
                HStack {
                    Button {
                        coordinator.showAuthLoginView()
                    } label: {
                        Text(isLogin ? "Выйти" : "Войти в аккаунт")
                            .foregroundColor(isLogin ? Colors.Primary.honeyFlower700Purple : .white)
                            .font(.system(size: 16, weight: isLogin ? .medium : .bold))
                    }
                    .frame(width: 160, height: 35)
                    .background(isLogin ? Colors.Primary.moonRaker300Purple : Colors.Primary.lavender500Purple)
                    .cornerRadius(35 / 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.bottom, -24)
            }
            
            HStack {
                Image(isLogin ? "сharacter_good" : "character_normal")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 135, height: 140)
            }
            .frame(maxWidth: 135, maxHeight: 140, alignment: .bottomTrailing)
            .padding(.bottom, -20)
            .padding(.trailing, -20)
        }
        .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)
        .background(isLogin ? Color(hex: "F0E8FA") : Color(hex: "333877"))
        .compositingGroup()
        .cornerRadius(15)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
    
    @ViewBuilder
    private func createAnalyticView() -> some View {
        HStack(spacing: 16) {
            VStack(spacing: 14) {
                Image("emoji_happy")
                    .resizable()
                    .frame(width: 38, height: 38)
                
                ZStack {
                    Text("9999")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                .frame(width: 86, height: 32)
                .background(Colors.Primary.lavender500Purple)
                .cornerRadius(32 / 2)
                
                Text("Положительных\nэмоций")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
            
            VStack(spacing: 14) {
                
                Image("emoji_sad")
                    .resizable()
                    .frame(width: 38, height: 38)
                
                ZStack {
                    Text("9999")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                .frame(width: 86, height: 32)
                .background(Colors.Primary.lavender500Purple)
                .cornerRadius(32 / 2)
                
                Text("Отрицательных\nэмоций")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)

            VStack(spacing: 14) {
                Image("emoji_cool")
                    .resizable()
                    .frame(width: 38, height: 38)
                
                ZStack {
                    Text("9999")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                .frame(width: 86, height: 32)
                .background(Colors.Primary.lavender500Purple)
                .cornerRadius(32 / 2)
                
                Text("Всего дней\n")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)

        }
        .frame(width: UIScreen.main.bounds.width, height: 128)
        .padding(.top, 24)
        .background(.white)
        
    }
    
    @ViewBuilder
    private func createArrowBlock(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 16))
            
            Spacer()
            
            Image(systemName: "chevron.forward")
        }
    }
}


