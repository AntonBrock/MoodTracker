//
//  FeelingViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 26.12.2022.
//

import SwiftUI

class FeelingViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    
    // MARK: - Init
    init(
        container: DIContainer
    ) {
        self.container = container
    }
}
