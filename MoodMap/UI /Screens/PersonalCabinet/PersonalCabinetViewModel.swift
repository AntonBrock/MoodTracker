//
//  PersonalCabinetViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import SwiftUI
import OneSignal

extension PersonalCabinetView {
    class ViewModel: ObservableObject {
        
        @Published var pushNotification: Bool = false
        @Published var userInfoModel: UserInfoModel?
        
        let notificationCenter = NotificationCenter.default

        func singUp(with GToken: String) {
            Services.authService.singUp(with: GToken) { [weak self] result in
                switch result {
                case .success(let jwtToken):
                    AppState.shared.jwtToken = jwtToken
                    AppState.shared.isLogin = true
                    self?.setLanguage()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func setLanguage() {
            Services.authService.setLanguage { [weak self] result in
                switch result {
                case .success:
                    self?.getUserInfo()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func singUp(appleIDToken: String) {
            Services.authService.singUp(appleIDToken: appleIDToken) { [weak self] result in
                switch result {
                case .success(let jwtToken):
                    AppState.shared.jwtToken = jwtToken
                    AppState.shared.isLogin = true
                    
                    self?.setLanguage()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func getUserInfo() {
            Services.authService.getUserInfo() { [weak self] result in
                switch result {
                case .success(let model):
                    
                    // Проверка были ли включены пуши у юезра, если не было запроса - спросить
                    OneSignal.promptForPushNotifications(userResponse: { accepted in
                        OneSignal.initWithLaunchOptions()
                        OneSignal.setAppId("da77481a-ba27-43f6-8771-37227b99d2e3")
                        
                        // Если пуши включают - задаем id для бэка
                        OneSignal.setExternalUserId(model.id)
                        AppState.shared.userPushNotification = true
                    })
                    
                    AppState.shared.notificationCenter.post(name: Notification.Name.MainScreenNotification, object: nil)
                    AppState.shared.notificationCenter.post(name: Notification.Name.JournalScreenNotification, object: nil)

                    self?.userInfoModel = model
                    self?.pushNotification = model.settings.notifications
                    
                    AppState.shared.userName = model.username
                    AppState.shared.userEmail = model.email
                    AppState.shared.userPushNotification = model.settings.notifications
                    AppState.shared.userLanguage = model.settings.language
                    AppState.shared.userLimits = model.limits[0].currentValue
                    AppState.shared.maximumValueOfLimits = model.limits[0].maximumValue
                    AppState.shared.timezone = model.settings.timezone
                    
                    self?.notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
                    self?.notificationCenter.post(name: Notification.Name("NotDisabledTabBarNavigation"), object: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
