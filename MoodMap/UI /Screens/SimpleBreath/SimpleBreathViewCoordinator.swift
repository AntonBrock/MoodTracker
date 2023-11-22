//
//  SimpleBreathViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 22.11.2023.
//

import SwiftUI

class SimpleBreathViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    unowned let parent: BaseViewCoordinator
    
    @ObservedObject var viewModel: SimpleBreathView.ViewModel
    
    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = SimpleBreathView.ViewModel()
    }
}
