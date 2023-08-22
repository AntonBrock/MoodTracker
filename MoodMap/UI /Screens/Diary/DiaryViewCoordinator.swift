//
//  DiaryViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.12.2022.
//

import SwiftUI

class DiaryViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    unowned let parent: BaseViewCoordinator
    @ObservedObject var viewModel: DiaryView.ViewModel

        
    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = DiaryView.ViewModel()
    }
}
