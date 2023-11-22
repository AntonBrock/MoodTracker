//
//  SimpleBreathCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 22.11.2023.
//

import Foundation
import SwiftUI

struct SimpleBreathCoordinatorView: View {
    
    @ObservedObject var coordinator: SimpleBreathViewCoordinator
    
    var body: some View {
        NavigationView {
            SimpleBreathView(coordinator: coordinator)
                .navigationTitle("")
        }
    }
}
