//
//  DiaryModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 02.04.2023.
//

import Foundation

struct DiaryModel: Decodable {
    let id: String
    let diaryPage: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case diaryPage = "text"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        diaryPage = try container.decode(String.self, forKey: .diaryPage)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
