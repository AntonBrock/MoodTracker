//
//  PersonalCabinetViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import SwiftUI
import NotificationCenter
import OneSignal

extension PersonalCabinetView {
    class ViewModel: ObservableObject {
        
        @Published var pushNotification: Bool = false
        @Published var userInfoModel: UserInfoModel?
        
        @Published var viewer: PersonalCabinetView?
        
        let notificationCenter = NotificationCenter.default
        
        func setupViewer(_ viewer: PersonalCabinetView) {
            self.viewer = viewer
        }

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
                                        
                    withAnimation {
                        self?.viewer?.coordinator.parent.isShowingPushNotificationScreen = true
                    }
                    
                    AppState.shared.notificationCenter.post(name: Notification.Name.MainScreenNotification, object: nil)
                    AppState.shared.notificationCenter.post(name: Notification.Name.JournalScreenNotification, object: nil)

                    self?.userInfoModel = model
                    
                    AppState.shared.userName = model.username
                    AppState.shared.userEmail = model.email
//                    AppState.shared.userPushNotification = model.settings.notifications
                    AppState.shared.userLanguage = model.settings.language
                    AppState.shared.userLimits = model.limits[0].currentValue
                    AppState.shared.maximumValueOfLimits = model.limits[0].maximumValue
                    AppState.shared.userID = model.id
                    AppState.shared.timezone = model.settings.timezone
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        private func updatePushNotificationSettings(pushNotificationIsEnabled: Bool, completion: @escaping (() -> Void)) {
            Services.authService.updatePushNotification(
                updatePushNotificationToggle: pushNotificationIsEnabled) { result in
                    switch result {
                    case let .success(isOn):
                        AppState.shared.userPushNotification = isOn
                        completion()
                    case .failure(let error):
                        AppState.shared.userPushNotification = false
                        print(error)
                    }
                }
        }
    }
}
