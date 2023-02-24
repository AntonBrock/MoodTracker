//
//  ActivitiesViewCoodinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class ActivitiesViewCoodinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
            
    // MARK: - Init
    init(
//        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
//        self.parent = parent
        self.container = container
    }
}
