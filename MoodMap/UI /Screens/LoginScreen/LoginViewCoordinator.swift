//
//  LoginViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 15.01.2023.
//

import SwiftUI

class LoginViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    private unowned let parent: BaseViewCoordinator
        
    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
    }
}

