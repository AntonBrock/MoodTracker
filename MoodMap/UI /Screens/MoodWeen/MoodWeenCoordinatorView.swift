//
//  MoodWeenCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.10.2023.
//

import SwiftUI

struct MoodWeenCoordinatorView: View {
    
    @ObservedObject var coordinator: MoodWeenViewCoordinator
    
    var body: some View {
        MoodWeenView()
    }
}
