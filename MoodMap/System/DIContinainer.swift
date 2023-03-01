//
//  DIContinainer.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import Foundation

struct DIContainer {
    let appState: AppState
    let services: Services
}

extension DIContainer {
    static var preview: Self {
        .init(
            appState: AppState.preview, services: Services()
        )
    }
    
    static var live: Self {
        .init(appState: AppState.live, services: Services())
    }
}
