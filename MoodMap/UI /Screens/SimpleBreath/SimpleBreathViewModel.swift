//
//  SimpleBreathViewModel.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 22.11.2023.
//

import Foundation
import SwiftUI

extension SimpleBreathView {
    class ViewModel: ObservableObject {
        
        @Published var viewer: SimpleBreathView?
        
        // MARK: - Public
        func setupViewer(_ viewer: SimpleBreathView) {
            self.viewer = viewer
        }
    }
}
