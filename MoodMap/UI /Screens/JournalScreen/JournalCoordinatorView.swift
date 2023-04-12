//
//  JournalCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct JournalCoordinatorView: View {
    
    @ObservedObject var coordinator: JournalViewCoordinator
    @Namespace var animation

    var body: some View {
        NavigationView {
            JournalView(coordinator: coordinator,
                        animation: animation)
            .navigationTitle("Журнал")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
