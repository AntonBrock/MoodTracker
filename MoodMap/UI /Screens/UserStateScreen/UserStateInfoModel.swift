//
//  UserStateInfoModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import Foundation

struct UserStateInfoModel {
    let state: String
    let emotion: String
    let activities: [String]
    let createdAt: Date?
    let stress: String
}
