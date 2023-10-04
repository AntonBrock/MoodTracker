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
    @State var isNeedShowAuthPopupFromLaunchScreen: Bool = false
    
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
                    ContentView(
                        coordinator: parent,
                        isNeedShowAuthPopupFromLaunchScreen: $isNeedShowAuthPopupFromLaunchScreen
                    )
                }
            }
            
            ZStack {
                Color("LaunchScreenBG")
                    .ignoresSafeArea()
                
                LottieView(name: "SplashScreen", loopMode: .loop)
                    .onAppear {
                        
                        let timeZone = TimeZone.current
                        let timeZoneIdentifier = timeZone.identifier
                        
                        AppState.shared.timezone = timeZoneIdentifier
                        
                        if AppState.shared.isLogin ?? false {
                            if AppState.shared.timezone != nil && timeZoneIdentifier != AppState.shared.timezone {
                                AppState.shared.timezone = timeZoneIdentifier
                                // запрос на обновление зоны
                                Services.authService.updateTimezone { result in
                                    switch result {
                                    case .success:
                                        print("Success updated timezone")
                                    case .failure:
                                        isNeedShowAuthPopupFromLaunchScreen = true
                                        withAnimation(.spring()) {
                                            animatedIsFinished = true
                                            isLoadingMainInfo = true
                                        }
                                    }
                                }
                            }
                        } else {
                            isNeedShowAuthPopupFromLaunchScreen = true
                            withAnimation(.spring()) {
                                animatedIsFinished = true
                                isLoadingMainInfo = true
                            }
                        }
                        
                        // тут делаем запрос на данные для Главного экрана потом и вырубаем либо при показе АТТ, Пушах, Главной
                        if AppState.shared.isLogin ?? false {
                            getUserInfo { needShowAuthPopUp in
                                isNeedShowAuthPopupFromLaunchScreen = needShowAuthPopUp

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.spring()) {
                                        animatedIsFinished = true
                                        isLoadingMainInfo = true
                                    }
                                }
                            }
                        } else {
                            isNeedShowAuthPopupFromLaunchScreen = true

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
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .onAppear {
            if let showATT = AppState.shared.isShowATT, showATT {
                isShowATTScreen = true
            }
            isSplashScreenShow.toggle()
        }
    }
    
    func getUserInfo(completion: @escaping ((_ needShowAuthPopUp: Bool) -> Void)) {
        if !checkJWTIsValid() {
            if checkRefreshTokenIsValid() {
                Services.authService.refreshToken { result in
                    switch result {
                    case .success:
                        Services.authService.getUserInfo() { result in
                            switch result {
                            case let .success(model):
                                AppState.shared.userName = model.username
                                AppState.shared.userEmail = model.email
                                AppState.shared.userPushNotification = model.settings.notifications
                                AppState.shared.userLanguage = model.settings.language
                                AppState.shared.userLimits = model.limits[0].currentValue
                                AppState.shared.maximumValueOfLimits = model.limits[0].maximumValue

                                completion(false)
                            case .failure:
                                AppState.shared.userName = nil
                                AppState.shared.userEmail = nil
                                AppState.shared.userPushNotification = false
                                AppState.shared.userLanguage = "russian"
                                AppState.shared.userLimits = 0
                                AppState.shared.maximumValueOfLimits = 5
                                AppState.shared.isLogin = false
                                AppState.shared.refreshToken = nil
                                AppState.shared.jwtToken = nil
                                completion(true)
                            }
                        }
                    case .failure(let error):
                        guard let errorLocaloze = error as? MMError else {
                            AppState.shared.userName = nil
                            AppState.shared.userEmail = nil
                            AppState.shared.userPushNotification = false
                            AppState.shared.userLanguage = "russian"
                            AppState.shared.userLimits = 0
                            AppState.shared.maximumValueOfLimits = 5
                            AppState.shared.isLogin = false
                            AppState.shared.refreshToken = nil
                            AppState.shared.jwtToken = nil
                            completion(true)
                            return
                        }
                       
                        if errorLocaloze == .defined(.tokenUndefined) {
                            AppState.shared.userName = nil
                            AppState.shared.userEmail = nil
                            AppState.shared.userPushNotification = false
                            AppState.shared.userLanguage = "russian"
                            AppState.shared.userLimits = 0
                            AppState.shared.maximumValueOfLimits = 5
                            AppState.shared.isLogin = false
                            AppState.shared.refreshToken = nil
                            AppState.shared.jwtToken = nil
                            completion(true)
                        } else {
                            AppState.shared.userName = nil
                            AppState.shared.userEmail = nil
                            AppState.shared.userPushNotification = false
                            AppState.shared.userLanguage = "russian"
                            AppState.shared.userLimits = 0
                            AppState.shared.maximumValueOfLimits = 5
                            AppState.shared.isLogin = false
                            AppState.shared.refreshToken = nil
                            AppState.shared.jwtToken = nil
                            completion(true)
                        }
                    }
                }
            } else {
                AppState.shared.userName = nil
                AppState.shared.userEmail = nil
                AppState.shared.userPushNotification = false
                AppState.shared.userLanguage = "russian"
                AppState.shared.userLimits = 0
                AppState.shared.maximumValueOfLimits = 5
                AppState.shared.isLogin = false
                AppState.shared.refreshToken = nil
                AppState.shared.jwtToken = nil
                completion(true)
            }
        } else {
            Services.authService.getUserInfo() { result in
                switch result {
                case let .success(model):
                    AppState.shared.userName = model.username
                    AppState.shared.userEmail = model.email
                    AppState.shared.userPushNotification = model.settings.notifications
                    AppState.shared.userLanguage = model.settings.language
                    AppState.shared.userLimits = model.limits[0].currentValue
                    AppState.shared.maximumValueOfLimits = model.limits[0].maximumValue
                    AppState.shared.userID = model.id
                    completion(false)
                case .failure:
                    AppState.shared.userName = nil
                    AppState.shared.userEmail = nil
                    AppState.shared.userPushNotification = false
                    AppState.shared.userLanguage = "russian"
                    AppState.shared.userLimits = 0
                    AppState.shared.maximumValueOfLimits = 5
                    AppState.shared.isLogin = false
                    AppState.shared.refreshToken = nil
                    AppState.shared.jwtToken = nil
                    completion(true)
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
    
    private func checkRefreshTokenIsValid() -> Bool {
        guard let token = AppState.shared.refreshToken else { return false }
        
        do {
            let refresh = try decode(jwt: token)
            
            // Check expiration
            if let expiresAt = refresh.expiresAt {
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
            print("Failed to decode refresh token: \(error)")
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
        let pushNotificaionIsGranded: Bool = AppState.shared.userPushNotification ?? false
        let userIsRegistered: Bool = AppState.shared.userID != nil
        
        return withAnimation {
            if let rememberNotificationDate = AppState.shared.rememberPushNotificationDate,
               Date().timeIntervalSince(rememberNotificationDate) > Constants.timeoutRequestNotification {
                if !pushNotificaionIsGranded && userIsRegistered {
                    AppState.shared.rememberPushNotificationDate = Date()
                    return true
                } else { return false }
            } else if AppState.shared.rememberPushNotificationDate == nil {
                AppState.shared.rememberPushNotificationDate = Date()
                return false
            } else { return false }
        }
    }
}
