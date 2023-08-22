//
//  ReportViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

class ReportViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    private unowned let parent: BaseViewCoordinator
    
    @ObservedObject var viewModel: ReportScreen.ViewModel
    
    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = ReportScreen.ViewModel()
    }
}
