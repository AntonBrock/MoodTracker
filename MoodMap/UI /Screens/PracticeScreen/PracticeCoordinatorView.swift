//
//  PracticeCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 14.11.2023.
//

import SwiftUI

struct PracticeCoordinatorView: View {
    
    @ObservedObject var coordinator: PracticeViewCoordinator
    @Namespace var animation
    
    var body: some View {
        NavigationView {
            PracticeView(coordinator: coordinator,
                        animation: animation, wasOpenedFromTabBar: {
                
                Services.metricsService.sendEventWith(eventName: .openPracticeScreen)
                Services.metricsService.sendEventWith(eventType: .openPracticeScreen)
            })
            .navigation(item: $coordinator.diaryViewCoordinator) {
                DiaryCoordinatorView(coordinator: $0)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
            .navigation(item: $coordinator.breathCoordinator) {
                BreathCoordinatorView(coordinator: $0)
                    .navigationBarHidden(false)
                    .tint(.white)
                    .onDisappear {
                        withAnimation {
                            coordinator.parent.hideCustomTabBar = false
                        }
                    }
            }
            .navigation(item: $coordinator.simpleBreathCoordinator) {
                SimpleBreathCoordinatorView(coordinator: $0)
                    .navigationBarHidden(false)
                    .tint(.white)
                    .onDisappear {
                        withAnimation {
                            coordinator.parent.hideCustomTabBar = false
                        }
                    }
            }
            .navigationTitle("Практики")
            .navigationBarTitleDisplayMode(.large)
            .accentColor(.black)
        }
    }
}