//
//  MainViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

class MainViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    private unowned let parent: BaseViewCoordinator
    
    @Published var diaryViewCoordinator: DiaryViewCoordinator?
    @Published var journalViewCoordinator: JournalViewCoordinator?

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
    }
    
    func openAllJournal() {
        parent.isNeedShowTab = .jurnal
    }
    
    func openDetailsJournal(_ model: JournalViewModel) {
        print(model.title)
    }
    
    func openMoodCheckScreen() {
        parent.isShowingMoodCheckScreen.toggle()
    }
}
