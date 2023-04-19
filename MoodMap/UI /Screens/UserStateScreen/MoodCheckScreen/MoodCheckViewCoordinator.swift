//
//  MoodCheckViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class MoodCheckViewCoordinator: ObservableObject, Identifiable {
    
    let parent: BaseViewCoordinator
    private let container: DIContainer
    
    @Published var sliderValueModele: SliderValueModele?
    @Published var activitiesViewCoordinator: ActivitiesViewCoodinator?
    
    @ObservedObject var userStateViewModel: MoodCheckView.ViewModel

    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.sliderValueModele = SliderValueModele()
        self.userStateViewModel = MoodCheckView.ViewModel()
    }
    
    func openAcitivitiesScreen(with userStateViewModel: MoodCheckView.ViewModel) {
        activitiesViewCoordinator = .init(
            parent: parent,
            container: container,
            userStateViewModel: userStateViewModel
        )
    }
}
