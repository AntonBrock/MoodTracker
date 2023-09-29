//
//  MoodCheckModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 27.09.2023.
//

import Foundation

struct MoodCheckModel: Decodable {
    let isCheckStateUser: Bool
    let isCreateNewDiaryNote: Bool
    let isBreathActivity: Bool
    
    enum CodingKeys: String, CodingKey {
        case isCheckStateUser = "has_new_diary_note_entry"
        case isCreateNewDiaryNote = "has_new_gratitude_entry"
        case isBreathActivity = "has_breath_activity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isCheckStateUser = try container.decode(Bool.self, forKey: .isCheckStateUser)
        isCreateNewDiaryNote = try container.decode(Bool.self, forKey: .isCreateNewDiaryNote)
        isBreathActivity = try container.decode(Bool.self, forKey: .isBreathActivity)
    }
}
