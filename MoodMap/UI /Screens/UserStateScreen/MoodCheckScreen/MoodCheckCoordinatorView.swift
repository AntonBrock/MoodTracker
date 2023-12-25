//
//  MoodCheckCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class SliderValueModele: ObservableObject {
    @Published var value: Double = 20
}

struct MoodCheckCoordinatorView: View {
    
    @ObservedObject var coordinator: MoodCheckViewCoordinator
    
    var body: some View {
        NavigationStack {
            MoodCheckView(container: .live, coordinator: coordinator,
                          valueModel: coordinator.sliderValueModele!)
            .navigation(item: $coordinator.activitiesViewCoordinator) {
                ActivitiesView(
                    parent: coordinator.parent,
                    container: .live,
                    coordinator: $0
                )
                    .navigationBarHidden(true)
                }
        }
    }
}
