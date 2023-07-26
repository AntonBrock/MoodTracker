//
//  Constants.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 13.04.2023.
//

import Foundation

enum Constants {
    
    #if DEBUG
    /// Если прошло 10 дней то необходимо снова спросить доступ к пушам
    static let timeoutRequestNotification: TimeInterval = 60 * 60 * 24 * 10
    #endif
    
    #if RELEASE
    /// Если прошло 10 минут то необходимо снова спросить доступ к пушам
    static let timeoutRequestNotification: TimeInterval = 60 * 10
    #endif

    /// Ссылка для Support в телеграм
    static let urlPathToSupport: String = "tg://resolve?domain=moodmapsupport"
    
    /// Если прошло 31 дней то необходимо снова сделать запрос на цитату и обновить ее на главном экране, а также сохранить в локальное хранилище
    static let timeoutRequestQuotes: TimeInterval = 60 * 60 * 24 * 31
}
