//
//  Constants.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 13.04.2023.
//

import Foundation

enum Constants {
    /// Если прошло 1 дней то необходимо снова спросить доступ к пушам
    static let timeoutRequestNotification: TimeInterval = 60 * 60 * 24 * 1

    /// Ссылка для Support в телеграм
    static let urlPathToSupport: String = "tg://resolve?domain=moodmapsupport"
    
    /// Если прошло 31 дней то необходимо снова сделать запрос на цитату и обновить ее на главном экране, а также сохранить в локальное хранилище
    static let timeoutRequestQuotes: TimeInterval = 60 * 60 * 24 * 31
}
