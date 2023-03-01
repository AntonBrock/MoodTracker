//
//  PersonalCabinetViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

class PersonalCabinetViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    private unowned let parent: BaseViewCoordinator
    
    var viewModel: PersonalCabinetView.PersonalCabinetViewModel!
    
    @Published var passwordScreen: LoginViewCoordinator?
    
    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = PersonalCabinetView.PersonalCabinetViewModel()
    }
    
    func openLoginView() {
        passwordScreen = .init(
            parent: parent,
            container: container
        )
    }
    
    func showAuthLoginView() {
        withAnimation {
            parent.showAuthLoginView.toggle()
        }
    }
}
