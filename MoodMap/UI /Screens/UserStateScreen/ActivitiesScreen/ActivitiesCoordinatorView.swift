//
//  ActivitiesCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

class SliderStressValueModele: ObservableObject {
    @Published var value: Double = 10
}

struct ActivitiesCoordinatorView: View {
    
    @ObservedObject var coordinator: ActivitiesViewCoodinator
    
    var body: some View {
        NavigationStack {
            ActivitiesView(parent: coordinator.parent,
                           container: .live,
                           coordinator: coordinator)
        }
    }
}
