//
//  BreathViewCoordinator.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.08.2023.
//

import SwiftUI

class BreathViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    unowned let parent: BaseViewCoordinator
    
    @Published var breathViewActive: BreathViewComponent?
    @Published var isBreathComponentActive = false

    @ObservedObject var viewModel: BreathView.ViewModel
    
    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = BreathView.ViewModel()
    }
}
