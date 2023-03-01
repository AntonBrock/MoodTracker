//
//  UserInfoModel.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation

struct UserInfoModel: Decodable, Hashable, Identifiable {
    
    let id: Int
    let firstName: String
    let lastName: String
    let patronymic: String
    let phone: String
    
}
