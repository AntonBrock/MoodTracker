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
    let language: String
    let image: String
    let createdAt: String?
    let updatedAt: String?
}
