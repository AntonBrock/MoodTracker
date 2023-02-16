//
//  ActivitiesCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 11.01.2023.
//

import SwiftUI

struct ActivitiesCoordinatorView: View {
    
    @ObservedObject var coordinator: ActivitiesViewCoodinator
    
    var body: some View {
        ActivitiesView(container: .live, coordinator: coordinator)
    }
}
