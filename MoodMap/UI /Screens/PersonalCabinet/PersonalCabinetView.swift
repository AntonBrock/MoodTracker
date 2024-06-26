//
//  PersonalCabinetView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct PersonalCabinetView: View {
    
    @ObservedObject var viewModel: ViewModel
    unowned let coordinator: PersonalCabinetViewCoordinator
        
    @State var pushNotification: Bool = AppState.shared.userPushNotification ?? false
    @State var showThatTelegramNotInstallView: Bool = false
    
    let notificationCenter = NotificationCenter.default
        
    init(
        coordinator: PersonalCabinetViewCoordinator,
        showAuthMethodView: Bool = false,
        isLogin: Bool = false
    ){
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
        self.viewModel.setupViewer(self)
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
                    
                    if AppState.shared.isLogin ?? false {
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
                                .disabled(!(AppState.shared.isLogin ?? false))
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!)
                                }

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
                    }
                   
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
                        .onTapGesture {
                            let url = URL.init(string: Constants.urlPathToPolitic)!
                            
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    .background(Colors.Primary.lightWhite)
                }
                .padding(.bottom, 24)
                .sheet(isPresented: $showThatTelegramNotInstallView) {
                    VStack {
                        Image("support_icon")
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                        
                        Text("Поддержка рядом")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Colors.Primary.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 49)
                            .padding(.bottom, 5)
                        
                        Text("Напиши нам на почту")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Colors.Primary.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("info@moodmap.com")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Colors.Primary.lavender500Purple)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Spacer()
                        
                        MTButton(buttonStyle: .outline, title: "Назад") {
                            showThatTelegramNotInstallView.toggle()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                        .padding(.horizontal, 24)
                        
                    }
                    .padding(.top, 85)
                    .padding(.bottom, 48)
                }
            }
        }
        .onChange(of: pushNotification, perform: { newValue in
            pushNotification = AppState.shared.userPushNotification ?? false
        })
        .onReceive(showLoader) { (output) in
            showLoaderView = true
            pushNotification = AppState.shared.userPushNotification ?? false
        }
        .onReceive(hideLoader) { (output) in
            showLoaderView = false
            pushNotification = AppState.shared.userPushNotification ?? false
        }
    }
    
    @ViewBuilder
    private func CreateLoginView(isLogin: Bool) -> some View {
        
        ZStack {
            Image(isLogin ? "ic-lk-authBackground" : "ic-lk-notauthBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 170, alignment: .leading)
        
            VStack {
                VStack(spacing: 4) {
                    Text(isLogin ? "Привет, \(AppState.shared.userName ?? "друг")" : "Привет, это")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Colors.Primary.lightGray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(isLogin ? "" : "Демо - режим")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isLogin ? Colors.Primary.lavender500Purple : .white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: -24, leading: 20, bottom: 0, trailing: 0))
                
                HStack {
                    Button {
                        if AppState.shared.isLogin ?? false {
                            coordinator.showLogoutView()
                        } else {
                            Services.metricsService.sendEventWith(eventName: .singInButton)
                            Services.metricsService.sendEventWith(eventType: .singInButton)

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
            
        }
        .frame(maxWidth: .infinity, maxHeight: 170.0, alignment: .leading)
        .cornerRadius(20)
        .padding(.horizontal, 5)
        .shadow(color: Colors.TextColors.slateGray700.opacity(0.5),
                radius: 10, x: 0, y: 0)
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


