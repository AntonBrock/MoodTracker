//
//  PersonalCabinetViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import SwiftUI

extension PersonalCabinetView {
    class ViewModel: ObservableObject {
        
        @Published var pushNotification: Bool = false
        @Published var userInfoModel: UserInfoModel?
        
        let notificationCenter = NotificationCenter.default
        
        init() {
            if AppState.shared.isLogin ?? false {
                getUserInfo()
            }
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
            notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
            notificationCenter.post(name: Notification.Name("NotDisabledTabBarNavigation"), object: nil)

            Services.authService.getUserInfo() { [weak self] result in
                switch result {
                case .success(let model):
                    
                    AppState.shared.notificationCenter.post(name: Notification.Name.MainScreenNotification, object: nil)
                    AppState.shared.notificationCenter.post(name: Notification.Name.JournalScreenNotification, object: nil)

                    self?.userInfoModel = model
                    self?.pushNotification = model.settings.notifications
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
