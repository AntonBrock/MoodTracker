//
//  DiaryCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.12.2022.
//

import SwiftUI

struct DiaryCoordinatorView: View {
    
    @ObservedObject var coordinator: DiaryViewCoordinator
    
    var body: some View {
        DiaryView(coordinator: coordinator)
            .navigationTitle("Дневник благодарности")
            .navigationBarTitleDisplayMode(.inline)
    }
}
