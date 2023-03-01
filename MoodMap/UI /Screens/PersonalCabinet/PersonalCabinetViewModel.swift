//
//  PersonalCabinetViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import SwiftUI

extension PersonalCabinetView {
    
    class PersonalCabinetViewModel {
        
        func singUp(with model: UserInfoModel) {
            Services.authService.singUp(with: model) { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
