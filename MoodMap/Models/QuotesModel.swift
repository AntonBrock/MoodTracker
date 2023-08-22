//
//  QuotesModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 22.07.2023.
//

import Foundation

struct QuotesModel: Decodable {
    let id: String
    let text: String
    let language: String
}
