//
//  BreathCoordinatorView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.08.2023.
//

import Foundation
import SwiftUI

struct BreathCoordinatorView: View {
    
    @ObservedObject var coordinator: BreathViewCoordinator
    
    var body: some View {
        NavigationView {
            BreathView(coordinator: coordinator)
                .navigationTitle("")
        }
    }
}
