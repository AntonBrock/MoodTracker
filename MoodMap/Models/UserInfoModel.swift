//
//  UserInfoModel.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation

struct UserInfoModel: Decodable {
    let id: String
    let username: String
    let email: String
    let created_at: String?
    let updated_at: String?
    let settings: Settings
    
    struct Settings: Decodable {
        let id: String
        let notifications: Bool
        let language: String
        let created_at: String
        let updated_at: String?
    }
}
