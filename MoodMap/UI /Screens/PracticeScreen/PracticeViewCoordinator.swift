//
//  PracticeViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 14.11.2023.
//

import SwiftUI

class PracticeViewCoordinator: ObservableObject, Identifiable {
    
    private let container: DIContainer
    unowned let parent: BaseViewCoordinator
    @ObservedObject var viewModel: PracticeView.ViewModel
    
    @Published var diaryViewCoordinator: DiaryViewCoordinator?
    @Published var breathCoordinator: BreathViewCoordinator?
    @Published var simpleBreathCoordinator: SimpleBreathViewCoordinator?
    
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
        self.viewModel = PracticeView.ViewModel()
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
    
    func openBreathScreen() {
        breathCoordinator = .init(
            parent: parent,
            container: container
        )
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
            parent.hideCustomTabBar = true
        }
    }
    
    func openSimpleBreathScreen() {
        simpleBreathCoordinator = .init(
            parent: parent,
            container: container
        )
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
            parent.hideCustomTabBar = true
        }
    }
}
