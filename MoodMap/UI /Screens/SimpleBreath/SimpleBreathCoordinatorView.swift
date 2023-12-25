//
//  SimpleBreathCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 22.11.2023.
//

import Foundation
import SwiftUI

struct SimpleBreathCoordinatorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var coordinator: SimpleBreathViewCoordinator
    
    var body: some View {
        NavigationStack {
            SimpleBreathView(coordinator: coordinator)
                .navigationTitle("")
                .toolbarBackground(
                    colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white,
                    for: .navigationBar
                )
        }
    }
}
