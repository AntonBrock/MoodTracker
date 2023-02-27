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
    
    // MARK: - Init
    init(
        container: DIContainer
    ) {
        self.container = container
        self.sliderValueModele = SliderStressValueModele()
    }
}
