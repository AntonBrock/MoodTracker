//
//  PersonalCabinetCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct PersonalCabinetCoordinatorView: View {
    
    @ObservedObject var coordinator: PersonalCabinetViewCoordinator
//    @Binding var isShowingTabBar: Bool
    
    init(coordinator: PersonalCabinetViewCoordinator) {
        self.coordinator = coordinator
        self.coordinator.parent.personalCabinetCoordinator.viewModel.viewer = PersonalCabinetView(coordinator: coordinator)
    }

    var body: some View {
        NavigationView {
            PersonalCabinetView(coordinator: coordinator)
                .navigationTitle("Профиль")
                .navigationBarTitleDisplayMode(.large)
                .navigation(item: $coordinator.passwordScreen) {
                    LoginCoordinatorView(coordinator: $0)
                }
        }
    }
}
