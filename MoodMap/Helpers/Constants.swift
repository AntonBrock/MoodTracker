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
    /// Ссылка для Политику
    static let urlPathToPolitic: String = "https://mapmood.com/privacy/ru"
    
    /// Если прошло 1 дней то необходимо снова сделать запрос на цитату и обновить ее на главном экране, а также сохранить в локальное хранилище
    static let timeoutRequestQuotes: TimeInterval = 86400 // Для теста - 120
}
