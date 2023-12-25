//
//  PersonalCabinetCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct PersonalCabinetCoordinatorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var coordinator: PersonalCabinetViewCoordinator

    init(coordinator: PersonalCabinetViewCoordinator) {
        self.coordinator = coordinator
        self.coordinator.parent.personalCabinetCoordinator.viewModel.viewer = PersonalCabinetView(coordinator: coordinator)
    }

    var body: some View {
        NavigationStack {
            PersonalCabinetView(coordinator: coordinator)
                .navigationTitle("Профиль")
                .toolbarBackground(
                    colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white,
                    for: .navigationBar
                )
                .navigationBarTitleDisplayMode(.large)
                .navigation(item: $coordinator.passwordScreen) {
                    LoginCoordinatorView(coordinator: $0)
                }
        }
    }
}
