//
//  AppState .swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

final class AppState: ObservableObject {

    static let shared = AppState()
    
    @Published var settings = Settings.initializeSettings()
    
    enum KeychainKeys {
        static let accountKey = "CHKeychain"
        
        static let jwtService = "JWT"
        static let refreshTokenService = "refreshToken"
        static let isAuthorizated = "isAuthorizated"
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
    
    var isLogin: Bool? {
        get {
            return KeychainHelper.standard.read(
                service: KeychainKeys.isAuthorizated,
                account: KeychainKeys.accountKey,
                type: Bool.self
            )
        }
        set {
            KeychainHelper.standard.save(
                newValue,
                service: KeychainKeys.isAuthorizated,
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
    
    func startStory(type: UserStoryType, container: DIContainer) {
        guard UIApplication.shared.connectedScenes.first?.delegate is SceneDelegate else {
            fatalError()
        }
    }
    
    func logout(container: DIContainer) {
        jwtToken = nil
        refreshToken = nil
        startStory(type: .login, container: container)
    }
    
//    static var settings = Settings.initializeSettings()
}
