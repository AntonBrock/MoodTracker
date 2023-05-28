//
//  JournalModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.03.2023.
//

import Foundation

struct JournalModel: Decodable {
            
    let id: String
    let text: String
    let createdAt: Date
    let updatedAt: Date?
    let stateId: String
    let emotionId: String
    let stressRate: String
    let userId: String
    let activities: [ActivitiesModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case stressRate = "stress_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case emotionId = "emotion_id"
        case userId = "user_id"
        case stateId = "state_id"
        case activities = "activities"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
        stateId = try container.decode(String.self, forKey: .stateId)
        stressRate = try container.decode(String.self, forKey: .stressRate)
        emotionId = try container.decode(String.self, forKey: .emotionId)
        userId = try container.decode(String.self, forKey: .userId)
        activities = try container.decode([ActivitiesModel].self, forKey: .activities)
    }
}
