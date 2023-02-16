//
//  AppEnvironment.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

public enum AppEnvironment: Int, CaseIterable {
    
    case production = 0
    case development = 1
    case test = 2
    
    var URLPrefix: String {
        switch self {
        case .development: return "crcal-dev"
        case .production:  return ""
        case .test:        return "test"
        }
    }
    
    var commonBaseURL: String {
        switch self {
        case .development: return "sovcombank.ru/app"
        case .production:  return ""
        case .test:        return "credrating.ru/jp"
        }
    }
    
    var stringValue: String {
        return AppEnvironment.stringValues[self.rawValue][0]
    }
    
    static func environment(for string: String) -> AppEnvironment? {
        
        for i in stringValues.indices {
            let arr = stringValues[i]
            if arr.contains(string) {
                return AppEnvironment(rawValue: i)
            }
        }
        return nil
    }
    
    private static let stringValues: [[String]] = [
        ["production", "prod"],
        ["development", "dev"],
        ["test", "test"]
    ]
    
}

// MARK: - Settings
final class Settings {
    
    let isDebug: Bool
    var environment: AppEnvironment
    
    init(isDebug: Bool, env: AppEnvironment) {
        self.isDebug = isDebug
        self.environment = env
    }
    
    convenience init?(dict: NSDictionary) {
        
        guard
            let debug = dict["DEBUG"] as? Bool,
            let envStr = dict["ENVIRONMENT"] as? String,
            let env = AppEnvironment.environment(for: envStr)
        else {
            return nil
        }
        
        self.init(isDebug: debug, env: env)
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "DEBUG": isDebug,
            "ENVIRONMENT": environment.stringValue
        ]
    }
}

extension Settings {
    static func initializeSettings() -> Settings {
        let path = Bundle.main.path(forResource: "Settings", ofType: "plist")!
        let dict = NSDictionary(contentsOf: URL(fileURLWithPath: path))!
        return Settings(dict: dict)!
    }
}
