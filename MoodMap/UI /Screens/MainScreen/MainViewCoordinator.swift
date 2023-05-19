//
//  MainViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

class MainViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    unowned let parent: BaseViewCoordinator
    
    @Published var diaryViewCoordinator: DiaryViewCoordinator?

    @ObservedObject var viewModel: MainView.ViewModel

    // MARK: - Init
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = MainView.ViewModel()
    }
    
    func openDiary() {
        diaryViewCoordinator = .init(
            parent: parent,
            container: container
        )
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
            parent.hideCustomTabBar = true
        }
    }
    
    func openAllJournal() {
        parent.isNeedShowTab = .jurnal
    }
    
    func openMoodCheckScreen() {
        parent.isShowingMoodCheckScreen.toggle()
    }
}
