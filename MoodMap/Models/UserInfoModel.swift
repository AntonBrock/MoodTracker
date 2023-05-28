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
    let deleted_at: String?
    let settings: Settings
    let limits: [Limits]
    
    struct Settings: Decodable {
        let id: String
        let notifications: Bool
        let language: String
        let timezone: String
        let created_at: String
        let updated_at: String?
    }
    
    struct Limits: Decodable {
        let currentValue: Int
        let maximumValue: Int
        
        enum CodingKeys: String, CodingKey {
            case currentValue = "current_value"
            case maximumValue = "maximum_value"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            currentValue = try container.decode(Int.self, forKey: .currentValue)
            maximumValue = try container.decode(Int.self, forKey: .maximumValue)
        }
    }
}
