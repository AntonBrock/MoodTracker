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
