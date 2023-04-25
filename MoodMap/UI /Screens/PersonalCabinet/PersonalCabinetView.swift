//
//  PersonalCabinetView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct PersonalCabinetView: View {
    
    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: PersonalCabinetViewCoordinator
        
    @State var pushNotification: Bool = false
    @State var showThatTelegramNotInstallView: Bool = false
    
    let notificationCenter = NotificationCenter.default
        
    init(
        coordinator: PersonalCabinetViewCoordinator,
        showAuthMethodView: Bool = false,
        isLogin: Bool = false
    ){
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
//        self.pushNotification = coordinator.viewModel.pushNotification
    }
    
    let showLoader = NotificationCenter.default.publisher(for: NSNotification.Name("ShowLoaderPersonalCabinet"))
    let hideLoader = NotificationCenter.default.publisher(for: NSNotification.Name("HideLoaderPersonalCabinet"))

    @State var showLoaderView: Bool = false
    
    var body: some View {
        
        VStack {
            if showLoaderView {
                VStack {
                    LoaderLottieView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    CreateLoginView(isLogin: AppState.shared.isLogin ?? false)
                        .background(.white)
                        .padding(.top, 16)
                        .padding(.horizontal, 24)
                    
                    VStack(spacing: 12) {
                        Text("ОСНОВНОЕ")
                            .frame(width: UIScreen.main.bounds.width - 32, height: 56, alignment: .bottomLeading)
                            .foregroundColor(Colors.Primary.lightGray)
                            .font(.system(size: 12))
                        
                        VStack {
                            Toggle(isOn: $pushNotification) {
                                Text("Напоминания")
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                            .tint(Colors.Primary.lavender500Purple)
                            //                    createArrowBlock("Создание пароля")
                            //                        .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                            //                        .padding(.trailing, 5)
                            //                        .onTapGesture {
                            //                            coordinator.openLoginView()
                            //                        }
                            
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
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .background(.white)
                        .onTapGesture {
                            let url = URL.init(string: Constants.urlPathToSupport)!
                            
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                            } else {
                                showThatTelegramNotInstallView.toggle()
                            }
                        }
                        
                        VStack {
                            createArrowBlock("Пользовательское соглашение")
                                .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                                .padding(.trailing, 5)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .background(.white)
                        .padding(.top, -12)
                    }
                    .background(Colors.Primary.lightWhite)
                }
                .padding(.bottom, 24)
                .sheet(isPresented: $showThatTelegramNotInstallView) {
                    Text("Напишите нам на почту info@mapmood.com и мы вам ответим!")
                }
            }
        }
        .onChange(of: pushNotification, perform: { newValue in
            print(newValue)
        })
        .onReceive(showLoader) { (output) in
            showLoaderView = true
        }
        .onReceive(hideLoader) { (output) in
            showLoaderView = false
        }
    }
    
    @ViewBuilder
    private func CreateLoginView(isLogin: Bool) -> some View {
        HStack {
            VStack {
                VStack(spacing: 4) {
                    Text(isLogin ? "Привет, \(viewModel.userInfoModel?.username ?? "")" : "Привет, незнакомец")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Colors.Primary.lightGray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(isLogin ? "" : "Дэмо - режим")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isLogin ? Colors.Primary.lavender500Purple : .white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: -24, leading: 16, bottom: 0, trailing: 0))
                
                HStack {
                    Button {
                        if AppState.shared.isLogin ?? false {
                            coordinator.showLogoutView()
                        } else {
                            coordinator.showAuthLoginView()
                        }
                    } label: {
                        Text(isLogin ? "Выйти из аккаунта" : "Войти в аккаунт")
                            .foregroundColor(isLogin ? Colors.Primary.honeyFlower700Purple : .white)
                            .font(.system(size: 16, weight: isLogin ? .medium : .bold))
                    }
                    .frame(width: 200, height: 35)
                    .background(isLogin ? Colors.Primary.moonRaker300Purple : Colors.Primary.lavender500Purple)
                    .cornerRadius(35 / 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.bottom, -24)
            }
            
            HStack {
                Image(isLogin ? "ch-ic-good" : "ch-ic-fine")
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


