//
//  AppState .swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

final class AppState: ObservableObject {

    static var settings = Settings.initializeSettings()
}

// MARK: - Preview state
extension AppState {

    static var preview: AppState {
        let state = AppState()
        return state
    }
    
    static var live: AppState {
        let state = AppState()
        return state
    }
    
    func startStory(type: UserStoryType, container: DIContainer) {
        guard UIApplication.shared.connectedScenes.first?.delegate is SceneDelegate else {
            fatalError()
        }                
    }
}

// MARK: - Empty state
extension AppState {
    static var empty: AppState {
        let state = AppState()
        return state
    }
}
