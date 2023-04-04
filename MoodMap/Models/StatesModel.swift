//
//  StatesModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 09.03.2023.
//

import UIKit

struct StatesModel: Decodable {
    let id: String
    let text: String
    let rate: Int
    let language: String
    let image: String
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case rate
        case language
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        rate = try container.decode(Int.self, forKey: .rate)
        language = try container.decode(String.self, forKey: .language)
        image = try container.decode(String.self, forKey: .image)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try? container.decode(String.self, forKey: .updatedAt)
    }
}
