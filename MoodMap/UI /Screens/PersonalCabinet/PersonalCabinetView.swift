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
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var pushNotification: Bool = AppState.shared.userPushNotification ?? false
    @State var darkMode: Bool = false
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
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if showLoaderView {
                    VStack {
                        LoaderLottieView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        CreateLoginView(isLogin: AppState.shared.isLogin ?? false)
                            .background(.clear)
                            .padding(.top, 16)
                            .padding(.horizontal, 24)
                        
                        if AppState.shared.isLogin ?? false {
                            VStack(spacing: 12) {
                                Text("Основное")
                                    .frame(width: UIScreen.main.bounds.width - 32, height: 35, alignment: .bottomLeading)
                                    .foregroundColor(Colors.Primary.lightGray)
                                    .font(.system(size: 12))
                                
                                VStack {
                                    Toggle(isOn: $pushNotification) {
                                        Text("Напоминания")
                                    }
                                    .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
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
                                .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
                            }
                            .background(colorScheme == .dark ?  Color("Background") : Colors.Primary.lightWhite)
                        }
                        
                        #warning("TODO: В первой версии ТОЛЬКО темная")
//                        VStack(spacing: 5) {
//                            Text("Оформление")
//                                .frame(width: UIScreen.main.bounds.width - 32, height: 35, alignment: .bottomLeading)
//                                .foregroundColor(Colors.Primary.lightGray)
//                                .font(.system(size: 12))
//                            
//                            VStack {
//                                Toggle(isOn: $darkMode) {
//                                    Text("Темная тема")
//                                }
//                                .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
//                                .frame(width: UIScreen.main.bounds.width - 32, height: 64)
//                                .tint(Colors.Primary.lavender500Purple)
//                                .onTapGesture {
//                                    if darkMode {
//                                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
//                                    } else {
//                                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 24)
//                            .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
//                        }
//                        .background(colorScheme == .dark ?  Color("Background") : Colors.Primary.lightWhite)
                       
                        VStack(spacing: 12) {
                            Text("Дополнительно")
                                .frame(width: UIScreen.main.bounds.width - 32, height: 35, alignment: .bottomLeading)
                                .foregroundColor(Colors.Primary.lightGray)
                                .font(.system(size: 12))
                            
                            
                            VStack {
                                createArrowBlock("Поддержка")
                                    .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                                    .padding(.trailing, 5)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                            .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
                            .onTapGesture {
                                let url = URL.init(string: Constants.urlPathToSupport)!
                                
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                } else {
                                    showThatTelegramNotInstallView.toggle()
                                }
                            }
                            
                            VStack {
                                createArrowBlock("Состояние приложения")
                                    .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                                    .padding(.trailing, 5)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                            .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
                            .onTapGesture {
                                let url = URL.init(string: Constants.urlPathToSupport)!
                                
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                } else {
                                    showThatTelegramNotInstallView.toggle()
                                }
                            }
                            
                            #warning("TODO: Пока скрываем блок")
                            
//                            VStack {
//                                createArrowBlock("Пользовательское соглашение")
//                                    .frame(width: UIScreen.main.bounds.width - 32, height: 64)
//                                    .padding(.trailing, 5)
//                                
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding(.horizontal, 24)
//                            .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
//                            .padding(.top, -12)
//                            .onTapGesture {
//                                let url = URL.init(string: Constants.urlPathToPolitic)!
//                                
//                                if UIApplication.shared.canOpenURL(url) {
//                                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//                                }
//                            }
                        }
                        .background(colorScheme == .dark ? Color("Background") : Colors.Primary.lightWhite)

                        Text("Версия приложения: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(Colors.Primary.lightGray)
                            .font(.system(size: 12))
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 24)
                    .sheet(isPresented: $showThatTelegramNotInstallView) {
                        ZStack {
                            Color("Background")
                                .ignoresSafeArea()
                            
                            VStack {
                                Image("support_icon")
                                    .resizable()
                                    .frame(width: 200, height: 200, alignment: .center)
                                
                                Text("Поддержка рядом")
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(colorScheme == .dark ? Colors.Primary.lightWhite : Colors.Primary.blue)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 49)
                                    .padding(.bottom, 5)
                                
                                Text("Напиши нам на почту")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(colorScheme == .dark ? Colors.Primary.lightWhite : Colors.Primary.blue)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text("anton.brock1@gmail.com")
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
                            .frame(maxHeight: .infinity)
                            .background(colorScheme == .dark ? Color("Background") : .white)
                            .padding(.top, 85)
                            .padding(.bottom, 48)
                        }
                    }
                }
            }
        }
        .onAppear {
            darkMode = colorScheme == .dark
        }
        .onChange(of: pushNotification, perform: { newValue in
            pushNotification = AppState.shared.userPushNotification ?? false
        })
        .onChange(of: darkMode, perform: { newValue in
            darkMode = newValue
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
                    Text(isLogin ? "Привет, друг" : "Привет, сейчас")
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
        .shadow(color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.slateGray700.opacity(0.5),
                radius: 10, x: 0, y: 0)
    }
    
    @ViewBuilder
    private func createArrowBlock(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .font(.system(size: 16))
            Spacer()
            
            Image(systemName: "chevron.forward")
        }
    }
}


