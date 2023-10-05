//
//  MoodWeenViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.10.2023.
//

import SwiftUI

class MoodWeenViewCoordinator: ObservableObject, Identifiable {
    
//    private let container: DIContainer
//    unowned let parent: BaseViewCoordinator
    
    @ObservedObject var viewModel: MoodWeenView.ViewModel

    // MARK: - Init
    init(
//        parent: BaseViewCoordinator,
//        container: DIContainer
    ) {
//        self.parent = parent
//        self.container = container
        self.viewModel = MoodWeenView.ViewModel()
    }
}
