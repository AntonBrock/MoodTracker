//
//  MoodCheckViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class MoodCheckViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
//    private unowned let parent: BaseViewCoordinator
    
    @Published var activitiesViewCoordinator: ActivitiesViewCoodinator?
    
    // MARK: - Init
    init(
//        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
//        self.parent = parent
        self.container = container
    }
    
    func openAcitivitiesScreen() {
        activitiesViewCoordinator = .init(container: container)
    }
}
