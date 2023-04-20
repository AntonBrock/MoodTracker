//
//  BaseViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

class BaseViewCoordinator: ObservableObject {
    
    // MARK: - Stored properties
    @Published var reportCoordinator: ReportViewCoordinator!
    @Published var mainScreenCoordinator: MainViewCoordinator!
    @Published var journalCoordinator: JournalViewCoordinator!
    @Published var personalCabinetCoordinator: PersonalCabinetViewCoordinator!
    
    @Published var moodCheckCoordinator: MoodCheckViewCoordinator!
    @Published var activitiesCoordinator: ActivitiesViewCoodinator!
    
    @Published var feelingCoordinator: FeelingViewCoordinator!
    
    @Published var showAuthLoginView: Bool = false
    @Published var showLogoutView: Bool = false
    @Published var isShowingWhyResgistration: Bool = false
    @Published var showDeleteAccountView: Bool = false

    @Published var isShowingMoodCheckScreen: Bool = false
    @Published var isNeedShowTab: Page = .home
    
    let container: DIContainer
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
        
        self.personalCabinetCoordinator = .init(
            parent: self,
            container: container
        )
        
        self.journalCoordinator = .init(
            parent: self,
            container: container
        )
        
        self.reportCoordinator = .init(
            parent: self,
            container: container
        )
        
        self.mainScreenCoordinator = .init(
            parent: self,
            container: container
        )
        
        self.feelingCoordinator = .init(
            container: container
        )
        
        self.moodCheckCoordinator = .init(
            parent: self,
            container: container
        )
        
        self.activitiesCoordinator = .init(
            parent: self,
            container: container,
            userStateViewModel: MoodCheckView.ViewModel()
        )
    }
    
    func openFeelingScreen() -> some View {
        let coordinator = self.moodCheckCoordinator!
        let feelingView = MoodCheckCoordinatorView(coordinator: coordinator)
        
        return feelingView
    }
}
