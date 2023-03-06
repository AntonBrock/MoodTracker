//
//  MoodCheckViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class MoodCheckViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    @Published var sliderValueModele: SliderValueModele?
    @Published var activitiesViewCoordinator: ActivitiesViewCoodinator?
    @ObservedObject var userStateViewModel: MoodCheckView.ViewModel

    // MARK: - Init
    init(
        container: DIContainer
    ) {
        self.container = container
        self.sliderValueModele = SliderValueModele()
        self.userStateViewModel = MoodCheckView.ViewModel()
    }
    
    func openAcitivitiesScreen(with userStateViewModel: MoodCheckView.ViewModel) {
        activitiesViewCoordinator = .init(container: container,
                                          userStateViewModel: userStateViewModel)
    }
}
