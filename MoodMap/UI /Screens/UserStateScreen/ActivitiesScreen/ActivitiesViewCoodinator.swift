//
//  ActivitiesViewCoodinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class ActivitiesViewCoodinator: ObservableObject, Identifiable {
    
    let parent: BaseViewCoordinator
    private let container: DIContainer
    @Published var sliderValueModele: SliderStressValueModele?
    
    @ObservedObject var userStateViewModel: MoodCheckView.ViewModel

    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer,
        userStateViewModel: MoodCheckView.ViewModel
    ) {
        self.parent = parent
        self.container = container
        self.sliderValueModele = SliderStressValueModele()
        self.userStateViewModel = userStateViewModel
    }
}
