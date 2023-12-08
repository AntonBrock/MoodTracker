//
//  MetricsService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.05.2023.
//

import Foundation
import FirebaseAnalytics
import YandexMobileMetrica

private let secretKeyForGoogleAnalytics = "8mt9g7KrRWmA5e5nsTuR3Q"
private let _YMMApiKey = "4b568161-7c73-4320-a811-c913cbb383c0"

enum MetricsEventName: String {
    case singInWithGoogleButton = "singInWithGoogleButton"
    case createEmotionNoteButton = "createEmotionNoteButton"
    case createEmotionNoteButtonFromTopBlock = "createEmotionNoteButtonFromTopBlock"
    case stateNextButton = "stateNextButton"
    case openJournalScreen = "openJournalScreen"
    case openPracticeScreen = "openPracticeScreen"

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
    // Breath
    case openBreathScreen = "openBreathScreen"
    case choosedStepThreeBreath = "choosedStepThreeBreath"
    case choosedStepFourBreath = "choosedStepFourBreath"
    case choosedStepFiveBreath = "choosedStepFiveBreath"
    case choosedDefaultThemeBreath = "choosedDefaultThemeBreath"
    case choosedBirdsThemeBreath = "choosedBirdsThemeBreath"
    case choosedNightForestThemeBreath = "choosedNightForestThemeBreath"
    case choosedOceanThemeBreath = "choosedOceanThemeBreath"
    case choosedRainThemeBreath = "choosedRainThemeBreath"
    case startBreath = "startBreathPractice"
    case endEarlyBreathPracice = "endEarlyBreathPracice"
    case endHalfBreathPractice = "endHalfBreathPractice"
    case endFullBreathPractice = "endFullBreathPractice"
    
    case openSimpleBreathScreen = "openSimpleBreathScreen"
}

protocol MetricsServiceProtocol {
    func sendEventWith(eventName: MetricsEventName)
}

enum YMetricsEventType: String {
    case singInWithGoogleButton = "singInWithGoogleButton"
    case createEmotionNoteButton = "createEmotionNoteButton"
    case createEmotionNoteButtonFromTopBlock = "createEmotionNoteButtonFromTopBlock"
    case stateNextButton = "stateNextButton"
    case openJournalScreen = "openJournalScreen"
    case openPracticeScreen = "openPracticeScreen"

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
    // Breath
    case openBreathScreen = "openBreathScreen"
    case choosedStepThreeBreath = "choosedStepThreeBreath"
    case choosedStepFourBreath = "choosedStepFourBreath"
    case choosedStepFiveBreath = "choosedStepFiveBreath"
    case choosedDefaultThemeBreath = "choosedDefaultThemeBreath"
    case choosedBirdsThemeBreath = "choosedBirdsThemeBreath"
    case choosedNightForestThemeBreath = "choosedNightForestThemeBreath"
    case choosedOceanThemeBreath = "choosedOceanThemeBreath"
    case choosedRainThemeBreath = "choosedRainThemeBreath"
    case startBreath = "startBreathPractice"
    case endEarlyBreathPracice = "endEarlyBreathPracice"
    case endHalfBreathPractice = "endHalfBreathPractice"
    case endFullBreathPractice = "endFullBreathPractice"
    
    case openSimpleBreathScreen = "openSimpleBreathScreen"
}

public enum YMetricsProfileType {
    case profileId(Int)
    case score(Int)
}

protocol YMetricsServiceProtocol {
    var profile: YMMMutableUserProfile? { get set }
    func sendEventWith(eventType: YMetricsEventType)
    func sendProfile(profileType: YMetricsProfileType)
}

class MetricsService: MetricsServiceProtocol {
    
    var profile: YMMMutableUserProfile?

    init() {
        if AppState.shared.isLogin ?? false {
            let configuration = YMMYandexMetricaConfiguration.init(apiKey: _YMMApiKey)
            configuration?.sessionTimeout = 15
            configuration?.logs = false

            YMMYandexMetrica.activate(with: configuration!)

            profile = YMMMutableUserProfile()
            YMMYandexMetrica.setUserProfileID(String(AppState.shared.userEmail ?? ""))
        }
    }
    
    func sendEventWith(eventName: MetricsEventName) {
        var message = ""
        
        switch eventName {
        case .activitiesNextButton:
            message = "iOS: Активности были выбраны и кнопка 'Продолжить' нажата"
        case .createEmotionNoteButton:
            message = "iOS: Кнопка 'Сохранить' нажата и запись создана"
        case .createEmotionNoteButtonFromTopBlock:
            message = "iOS: Нажали создать запись кнопку наверху"
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
        case .openPracticeScreen:
            message = "iOS: Открыли Практики по табу"
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
        case .openBreathScreen:
            message = "iOS: Был открыт экран Дыхательной практики"
        case .choosedStepThreeBreath:
            message = "iOS: Выбрано 3 подхода в Дыхательной практики"
        case .choosedStepFourBreath:
            message = "iOS: Выбрано 4 подхода в Дыхательной практики"
        case .choosedStepFiveBreath:
            message = "iOS: Выбрано 5 подхода в Дыхательной практики"
        case .choosedDefaultThemeBreath:
            message = "iOS: Выбрана тема по-умолчанию в Дыхательной практики"
        case .choosedBirdsThemeBreath:
            message = "iOS: Выбрана тема Птицы в Дыхательной практики"
        case .choosedNightForestThemeBreath:
            message = "iOS: Выбрана тема Ночь в лесу в Дыхательной практики"
        case .choosedOceanThemeBreath:
            message = "iOS: Выбрана тема Океан в Дыхательной практики"
        case .choosedRainThemeBreath:
            message = "iOS: Выбрана тема Дождь в Дыхательной практики"
        case .startBreath:
            message = "iOS: Пользователь нажал на Кнопку запуска Дыхательной практики"
        case .endEarlyBreathPracice:
            message = "iOS: Пользователь завершил практику без прогресса"
        case .endHalfBreathPractice:
            message = "iOS: Пользователь завершил практику на половине прогресса"
        case .endFullBreathPractice:
            message = "iOS: Пользователь завершил практику полностью"
        case .openSimpleBreathScreen:
            message = "iOS: Пользователь открыл упрощенную дыхательную практику"
        }
        
        let parameters = ["message": message]
        
        Analytics.logEvent(eventName.rawValue, parameters: parameters)
    }
    
    func sendEventWith(eventType: YMetricsEventType) {
        var message = ""
        
        switch eventType {
        case .activitiesNextButton:
            message = "iOS: Активности были выбраны и кнопка 'Продолжить' нажата"
        case .createEmotionNoteButtonFromTopBlock:
            message = "iOS: Нажали создать запись кнопку наверху"
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
        case .openPracticeScreen:
            message = "iOS: Открыли Практики по табу"
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
        case .openBreathScreen:
            message = "iOS: Был открыт экран Дыхательной практики"
        case .choosedStepThreeBreath:
            message = "iOS: Выбрано 3 подхода в Дыхательной практики"
        case .choosedStepFourBreath:
            message = "iOS: Выбрано 4 подхода в Дыхательной практики"
        case .choosedStepFiveBreath:
            message = "iOS: Выбрано 5 подхода в Дыхательной практики"
        case .choosedDefaultThemeBreath:
            message = "iOS: Выбрана тема по-умолчанию в Дыхательной практики"
        case .choosedBirdsThemeBreath:
            message = "iOS: Выбрана тема Птицы в Дыхательной практики"
        case .choosedNightForestThemeBreath:
            message = "iOS: Выбрана тема Ночь в лесу в Дыхательной практики"
        case .choosedOceanThemeBreath:
            message = "iOS: Выбрана тема Океан в Дыхательной практики"
        case .choosedRainThemeBreath:
            message = "iOS: Выбрана тема Дождь в Дыхательной практики"
        case .startBreath:
            message = "iOS: Пользователь нажал на Кнопку запуска Дыхательной практики"
        case .endEarlyBreathPracice:
            message = "iOS: Пользователь завершил практику без прогресса"
        case .endHalfBreathPractice:
            message = "iOS: Пользователь завершил практику на половине прогресса"
        case .endFullBreathPractice:
            message = "iOS: Пользователь завершил практику полностью"
        case .openSimpleBreathScreen:
            message = "iOS: Пользователь открыл упрощенную дыхательную практику"
        }
        
        let parameters = [eventType.rawValue: message]
        
        YMMYandexMetrica.reportEvent(eventType.rawValue, parameters: parameters, onFailure: nil)
    }
    
    func sendProfile(profileType: YMetricsProfileType) {
        guard let profile = profile else { return }

        switch profileType {
        case let .profileId(id):
            profile.apply(from: [YMMProfileAttribute.customNumber("ProfileID").withValue(Double(id))])
        case let .score(score):
            profile.apply(from: [YMMProfileAttribute.customNumber("Score").withValue(Double(score))])
        }
        
        YMMYandexMetrica.report(profile, onFailure: { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

class StubMetricsService: YMetricsServiceProtocol {
    
    var profile: YMMMutableUserProfile?
        
    func sendEventWith(eventType: YMetricsEventType) { }
    
    func sendProfile(profileType: YMetricsProfileType) { }
}

class MockMetricsService: YMetricsServiceProtocol {
    
    var profile: YMMMutableUserProfile?
        
    func sendEventWith(eventType: YMetricsEventType) { }
    
    func sendProfile(profileType: YMetricsProfileType) { }
}
