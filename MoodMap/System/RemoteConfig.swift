//
//  RemoteConfig.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 06.09.2023.
//

import Firebase

class RCValues {
    
    enum RemoteKeys: String {
        case reconfigureMainScreen = "mainScreen_update_position"
        case moodWeenEvent = "moodWeen"
    }
    
    static let sharedInstance = RCValues()
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    private func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            RemoteKeys.reconfigureMainScreen.rawValue : false,
            RemoteKeys.moodWeenEvent.rawValue : false
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    private func fetchCloudValues() {
        activateDebugMode()
        RemoteConfig.remoteConfig().fetch { [weak self] _, error in
            if let error = error {
                print("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            
            // 3
            RemoteConfig.remoteConfig().activate { _, _ in
                print("""
                  Our app's mainScreen_update_position \
                  \(RemoteConfig.remoteConfig().configValue(forKey: RCValues.RemoteKeys.reconfigureMainScreen.rawValue))
                  """)
            }
        }
    }
    
    private func activateDebugMode() {
        let settings = RemoteConfigSettings()
        if let number = Bundle.main.infoDictionary?["MinimumFetchIntervalRemoteConfig"] as? String {
            settings.minimumFetchInterval = TimeInterval(Int(number) ?? 0)
        } else {
            settings.minimumFetchInterval = 6
        }
        RemoteConfig.remoteConfig().configSettings = settings
    }
}

extension RCValues {
    func isEnableMainConfiguraation(forKey key: RemoteKeys) -> Bool {
        return RemoteConfig.remoteConfig()[key.rawValue]
            .boolValue
    }
}
