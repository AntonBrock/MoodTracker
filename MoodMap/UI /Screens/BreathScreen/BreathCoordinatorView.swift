//
//  BreathCoordinatorView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.08.2023.
//

import Foundation
import SwiftUI

struct BreathCoordinatorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var coordinator: BreathViewCoordinator
    
    var body: some View {
        NavigationStack {
            BreathView(coordinator: coordinator)
            .navigationTitle("")
            .toolbarBackground(
                colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white,
                for: .navigationBar
            )
        }
    }
}
