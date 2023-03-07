//
//  JournalViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

class JournalViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    private unowned let parent: BaseViewCoordinator
    
    @ObservedObject var viewModel: JournalView.ViewModel
    
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = JournalView.ViewModel()
    }
}
