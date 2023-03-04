//
//  PersonalCabinetViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import SwiftUI

extension PersonalCabinetView {
    class ViewModel: ObservableObject {
        
        @Published var isLogin: Bool = false
        @Published var pushNotification: Bool = false
        @Published var userInfoModel: UserInfoModel?

        func singUp(with GToken: String) {
            Services.authService.singUp(with: GToken) { [weak self] result in
                switch result {
                case .success(let jwtToken):
                    AppState.shared.jwtToken = jwtToken
                    AppState.shared.isLogin = true
                    self?.getUserInfo()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func getUserInfo() {
            Services.authService.getUserInfo() { [weak self] result in
                switch result {
                case .success(let model):
                    self?.userInfoModel = model
                    self?.pushNotification = model.settings.notifications
                    self?.isLogin = AppState.shared.isLogin ?? false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
