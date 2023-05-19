//
//  MetricsService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.05.2023.
//

import Foundation
import FirebaseAnalytics

private let _YMMApiKey = ""
private let secretKeyForGoogleAnalytics = "8mt9g7KrRWmA5e5nsTuR3Q"

enum MetricsEventName: String {
    case singInWithGoogleButton = "singInWithGoogleButton"
    case createEmotionNoteButton = "createEmotionNoteButton"
    case stateNextButton = "stateNextButton"
    case openJournalScreen = "openJournalScreen"
    case shareToInstagramButton = "shareToInstagramButton"
    case deleteAccAgreeButton = "deleteAccAgreeButton"
    case singInButton = "singInButton"
    case openDiaryScreenButton = "openDiaryScreenButton"
    case shareButtonFromJournalPage = "shareButtonFromJournalPage"
    case notAskAboutSharingButton = "notAskAboutSharingButton"
    case activitiesNextButton = "activitiesNextButton"
    case saveNewDiaryPageButton = "saveNewDiaryPageButton"
    case saveShareImageButton = "saveShareImageButton"
    case singInWithAppleButton = "singInWithAppleButton"
    case openDetailJournalScreen = "openDetailJournalScreen"
    case createNewDairyPageButton = "createNewDairyPageButton"
    case goToJournalFromMainScreenButton = "goToJournalFromMainScreenButton"
    case deleteAccButton = "deleteAccButton"
    case openReportScreen = "openReportScreen"
}

protocol MetricsServiceProtocol {
    func sendEventWith(eventName: MetricsEventName)
}

class MetricsService: MetricsServiceProtocol {
    
    func sendEventWith(eventName: MetricsEventName) {
        var message = ""
        
        switch eventName {
        case .activitiesNextButton:
            message = "iOS: Активности были выбраны и кнопка 'Продолжить' нажата"
        case .createEmotionNoteButton:
            message = "iOS: Кнопка 'Сохранить' нажата и запись создана"
        case .createNewDairyPageButton:
            message = "iOS: Кнопка 'Создать запись в дневнике благодарности' нажата"
        case .deleteAccAgreeButton:
            message = "iOS: Подтверждение удаление аккуанта нажато"
        case .deleteAccButton:
            message = "iOS: Кнопка 'Удалить' нажата"
        case .goToJournalFromMainScreenButton:
            message = "iOS: Переход в журнал из Главного экрана"
        case .notAskAboutSharingButton:
            message = "iOS: Нажата кнопка больше не спрашивать про поделиться состоянием"
        case .openDetailJournalScreen:
            message = "iOS: Открыт детальный обзор состояния в журнале"
        case .openDiaryScreenButton:
            message = "iOS: С Главного экрана открыли Дневник благодарности"
        case .openJournalScreen:
            message = "iOS: Открыли журнал по табу"
        case .saveNewDiaryPageButton:
            message = "iOS: Сохранили новую запись в Дневнике благодарности"
        case .saveShareImageButton:
            message = "iOS: Сохранили Состояние в изображения"
        case .shareToInstagramButton:
            message = "iOS: Сохранили Состояние в Инстаграмм"
        case .singInButton:
            message = "iOS: Кнопку Войти нажали"
        case .singInWithAppleButton:
            message = "iOS: Вошли с помощью Apple"
        case .singInWithGoogleButton:
            message = "iOS: Вошли с помощью Google"
        case .shareButtonFromJournalPage:
            message = "iOS: Нажали Поделиться состоянием через Журнал"
        case .stateNextButton:
            message = "iOS: Нажали кнопку 'Продолжить' после выбора состояния и настроения"
        case .openReportScreen:
            message = "iOS: Зашли в отчет через ТабБар"
        }
        
        let parameters = ["message": message]
        
        Analytics.logEvent(eventName.rawValue, parameters: parameters)
    }
}
