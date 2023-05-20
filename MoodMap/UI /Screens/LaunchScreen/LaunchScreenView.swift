//
//  LaunchScreenView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.04.2023.
//

import SwiftUI
import JWTDecode

struct LaunchScreenView: View {
    
    @State var isSplashScreenShow: Bool = false
    @State var animatedIsFinished: Bool = false
    
    @State var isLoadingMainInfo: Bool = false
    
    let parent: BaseViewCoordinator
    let container: DIContainer
    
    @State var isNeedShowPushNotificationScreen: Bool = false
    @State var isShowPushNotificationScreen: Bool = false
    
    @State var isShowATTScreen: Bool = false
    
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
    }
    
    var body: some View {
        
        ZStack {
            if isLoadingMainInfo {
                
                if needShowATT() && !isShowATTScreen {
                    ATTView {
                        AppState.shared.isShowATT = true
                        withAnimation {
                            self.isShowATTScreen = true
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    if !isShowPushNotificationScreen && needShowPushNotification() {
                        if AppState.shared.isLogin ?? false {
                            if AppState.shared.rememberPushNotificationDate == nil {
                                ContentView(coordinator: parent)
                                    .onAppear {
                                        AppState.shared.rememberPushNotificationDate = Date()
                                    }
                            } else {
                                PushNotificationView(closeAction: {
                                    withAnimation {
                                        self.isShowPushNotificationScreen = true
                                    }
                                })
                            }
                           
                        } else {
                            ContentView(coordinator: parent)
                        }
                    } else {
                        ContentView(coordinator: parent)
                    }
                }
            }
            
            ZStack {
                Color("LaunchScreenBG")
                    .ignoresSafeArea()
                
                LottieView(name: "SplashScreen", loopMode: .loop)
                    .onAppear {
                        
                        let timeZone = TimeZone.current
                        let timeZoneIdentifier = timeZone.identifier
                        
                        if AppState.shared.timezone != nil && timeZoneIdentifier != AppState.shared.timezone {
                            AppState.shared.timezone = timeZoneIdentifier
                            // запрос на обновление зоны
                            Services.authService.updateTimezone { result in
                                switch result {
                                case .success:
                                    print("Success updated timezone")
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else if AppState.shared.timezone == nil {
                            AppState.shared.timezone = timeZoneIdentifier
                        }
                        
                        // тут делаем запрос на данные для Главного экрана потом и вырубаем либо при показе АТТ, Пушах, Главной
                        if AppState.shared.isLogin ?? false {
                            getUserInfo {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.spring()) {
                                        animatedIsFinished = true
                                        isLoadingMainInfo = true
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.spring()) {
                                    animatedIsFinished = true
                                    isLoadingMainInfo = true
                                }
                            }
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .opacity(animatedIsFinished ? 0 : 1)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .onAppear {
            if let showATT = AppState.shared.isShowATT, showATT {
                isShowATTScreen = true
            }
            
            isSplashScreenShow.toggle()
        }
    }
    
    func getUserInfo(completion: @escaping (() -> Void)) {
        if !checkJWTIsValid() {
            Services.authService.refreshToken { result in
                switch result {
                case .success:
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            Services.authService.getUserInfo() { result in
                switch result {
                case let .success(model):
                    AppState.shared.userName = model.username
                    AppState.shared.userEmail = model.email
                    AppState.shared.userPushNotification = model.settings.notifications
                    AppState.shared.userLanguage = model.settings.language
                    
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    private func checkJWTIsValid() -> Bool {
        guard let token = AppState.shared.jwtToken else { return false }
        
        do {
            let jwt = try decode(jwt: token)
            
            // Check expiration
            if let expiresAt = jwt.expiresAt {
                let currentDate = Date()
                
                if currentDate > expiresAt {
                    print("Token is expired")
                    return false
                } else {
                    print("Token is valid")
                    return true
                }
            } else {
                print("Token does not have an expiration claim")
                return false
            }
            
        } catch {
            print("Failed to decode JWT token: \(error)")
            return false
        }
    }
    
    private func needShowATT() -> Bool {
        withAnimation {
            if let showATT = AppState.shared.isShowATT, showATT {
                return false
            } else {
                return true
            }
        }
    }
    
    private func needShowPushNotification() -> Bool {
        withAnimation {
            if let rememberNotificationDate = AppState.shared.rememberPushNotificationDate,
               Date().timeIntervalSince(rememberNotificationDate) > Constants.timeoutRequestNotification {
                AppState.shared.rememberPushNotificationDate = Date()
                return true
            } else if AppState.shared.rememberPushNotificationDate == nil {
                AppState.shared.rememberPushNotificationDate = Date()
                return true
            } else { return false }
        }
    }
}
