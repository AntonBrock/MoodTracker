//
//  MainCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct MainCoordinatorView: View {
    
    @ObservedObject var coordinator: MainViewCoordinator
    var animation: Namespace.ID
    
    var body: some View {
        NavigationView {
            MainView(container: .live, animation: animation, coordinator: coordinator)
                .navigationTitle("Главная")
                .navigationBarTitleDisplayMode(.large)
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
        }
        .accentColor(.black)
    }
}
