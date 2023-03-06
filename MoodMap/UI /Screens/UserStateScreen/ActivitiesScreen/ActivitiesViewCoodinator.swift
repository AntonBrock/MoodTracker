//
//  ActivitiesViewCoodinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class ActivitiesViewCoodinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    @Published var sliderValueModele: SliderStressValueModele?
    
    @ObservedObject var userStateViewModel: MoodCheckView.ViewModel

    // MARK: - Init
    init(
        container: DIContainer,
        userStateViewModel: MoodCheckView.ViewModel
    ) {
        self.container = container
        self.sliderValueModele = SliderStressValueModele()
        self.userStateViewModel = userStateViewModel
    }
}
