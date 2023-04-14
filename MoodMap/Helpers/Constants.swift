//
//  Constants.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 13.04.2023.
//

import Foundation

enum Constants {
    
    #warning("TODO: На проде")
    /// Если прошло 10 дней то необходимо снова спросить доступ к пушам
//    static let timeoutRequestNotification: TimeInterval = 60 * 60 * 24 * 10
    
    /// Если прошло 10 минут то необходимо снова спросить доступ к пушам
    static let timeoutRequestNotification: TimeInterval = 3 * 10 //60 * 10
}
