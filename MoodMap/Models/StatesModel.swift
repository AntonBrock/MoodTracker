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
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case rate
        case language
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        rate = try container.decode(Int.self, forKey: .rate)
        language = try container.decode(String.self, forKey: .language)
        image = try container.decode(String.self, forKey: .image)
    }
}
