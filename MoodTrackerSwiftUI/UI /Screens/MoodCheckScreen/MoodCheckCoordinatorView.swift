//
//  MoodCheckCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

struct MoodCheckCoordinatorView: View {
    
    @ObservedObject var coordinator: MoodCheckViewCoordinator
    
//    @Binding var isNeedToShowActivities: Bool
//    @Binding var isShowingMoodCheckView: Bool
//    @State var value: Double = 20
    
    var body: some View {
        NavigationView {
            MoodCheckView(container: .live, coordinator: coordinator,
                          valueModel: SliderValueModele())
            .navigation(item: $coordinator.activitiesViewCoordinator) {
                    ActivitiesView(container: .live, coordinator: $0)
                    .navigationBarHidden(true)
                }
        }
    }
}
