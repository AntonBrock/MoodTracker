//
//  FeelingCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 26.12.2022.
//

import SwiftUI

struct FeelingCoordinatorView: View {
    
    @ObservedObject var coordinator: FeelingViewCoordinator

    var body: some View {
        NavigationView {
            FeelingView()
                .navigationTitle("Что вы чувствуйте?")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
