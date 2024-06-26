//
//  AppState .swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

final class AppState: ObservableObject {

    @Published var settings = Settings.initializeSettings()

    static let shared = AppState()
        
    let notificationCenter = NotificationCenter.default
    
    var baseURL: String {
        get {
            guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] else {
                return "https://api.dev.mapmood.com"
            }
            return "https://\(baseURL)"
        }
    }
            
    enum KeychainKeys {
        static let accountKey = "CHKeychain"
        
        static let jwtService = "JWT"
        static let refreshTokenService = "refreshToken"
    }
    
    enum UserDefaultsKeys {
        static let isAuthorizated = "isAuthorizated"
        static let rememberPushNotificationDate = "rememberPushNotificationDate"
        static let quoteText = "quoteText"
        static let updateQuotesDate = "updateQuotesDate"
        static let isShowATT = "isShowATT"
        static let isNotShowSharingScreen = "isNotShowSharingScreen"
        static let timeZone = "timeZone"
        static let userName = "userName"
        static let userPushNotification = "userPushNotification"
        static let userLanguage = "userLanguage"
        static let userEmail = "userEmail"
        static let userLimits = "userLimits"
        static let userID = "userID"
        static let maximumValueOfLimits = "maximumValueOfLimits"
        static let isCompletedMoodCheck = "isCompletedMoodCheck"
        static let isMoodMapIconWasSeted = "isMoodMapIconWasSeted"
        
        //MoodWeen
        static let isMoodWeenIconWasSeted = "isMoodWeenIconWasSeted"
        static let currentValueGame = "currentValueGame"
        static let moodWeenGameIsEnabled = "moodWeenGameIsEnabled"
        static let moodWeenBannerShownFirstTime = "moodWeenBannerShownFirstTime"
    }
    
    var timezone: String? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.timeZone) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.timeZone)
        }
    }
    
    var rememberPushNotificationDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.rememberPushNotificationDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.rememberPushNotificationDate)
        }
    }
    
    var quoteText: String? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.quoteText) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.quoteText)
        }
    }
    
    var updateQuotesDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.updateQuotesDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.updateQuotesDate)
        }
    }
    
    var isShowATT: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isShowATT)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isShowATT)
        }
    }
    
    var isNotNeedShowSharingScreen: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNotShowSharingScreen)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isNotShowSharingScreen)
        }
    }
    
    var isLogin: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAuthorizated)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isAuthorizated)
        }
    }
    
    var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.userName)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userName)
        }
    }
    var userPushNotification: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.userPushNotification)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userPushNotification)
        }
    }
    var userLanguage: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.userLanguage)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userLanguage)
        }
    }
    var userEmail: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userEmail)
        }
    }
    
    var userLimits: Int? {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.userLimits)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userLimits)
        }
    }
    
    var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.userID)

        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userID)
        }
    }
    
    var maximumValueOfLimits: Int? {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.maximumValueOfLimits)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.maximumValueOfLimits)
        }
    }
    
    var isCompletedMoodCheck: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isCompletedMoodCheck)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isCompletedMoodCheck)
        }
    }
        
    // MoodWeen
    var isMoodWeenIconWasSeted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMoodWeenIconWasSeted)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isMoodWeenIconWasSeted)
        }
    }
    
    var isMoodMapIconWasSeted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMoodMapIconWasSeted)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isMoodMapIconWasSeted)
        }
    }
    
    var moodWeenGameStage: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentValueGame)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentValueGame)
        }
    }
    
    var moodWeenGameIsEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.moodWeenGameIsEnabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.moodWeenGameIsEnabled)
        }
    }
    
    var moodWeenBannerShownFirstTime: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.moodWeenBannerShownFirstTime)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.moodWeenBannerShownFirstTime)
        }
    }
    
    var jwtToken: String? {
        get {
            return KeychainHelper.standard.read(
                service: KeychainKeys.jwtService,
                account: KeychainKeys.accountKey,
                type: String.self
            )
        }
        set {
            KeychainHelper.standard.save(
                newValue,
                service: KeychainKeys.jwtService,
                account: KeychainKeys.accountKey
            )
            objectWillChange.send()
        }
    }

    var refreshToken: String? {
        get {
            return KeychainHelper.standard.read(
                service: KeychainKeys.refreshTokenService,
                account: KeychainKeys.accountKey,
                type: String.self
            )
        }
        set {
            KeychainHelper.standard.save(
                newValue,
                service: KeychainKeys.refreshTokenService,
                account: KeychainKeys.accountKey
            )
            objectWillChange.send()
        }
    }
    
    @Published var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

            if let date = formatter.date(from: dateStr) {
                return date
            }

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"

            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            fatalError()
        })

        return decoder
    }()
    
    func startStory(type: UserStoryType, parent: BaseViewCoordinator, container: DIContainer) {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError()
        }
        
        scene.startStory(type: type, parent: parent, container: container)
    }
    
    func logout(container: DIContainer) {
        jwtToken = nil
        refreshToken = nil
        startStory(type: .login, parent: BaseViewCoordinator(container: container), container: container)
    }
    
//    static var settings = Settings.initializeSettings()
}

extension Notification.Name {
    static let MainScreenNotification = Notification.Name("MainScreenNotification")
    static let JournalScreenNotification = Notification.Name("JournalScreenNotification")
}
