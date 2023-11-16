//
//  PracticeViewModel.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 14.11.2023.
//

import Foundation
import SwiftUI

extension PracticeView {
    class ViewModel: ObservableObject {
        
        @Published var viewer: PracticeView?
        
        func setupViewer(_ viewer: PracticeView) {
            self.viewer = viewer
            
            if AppState.shared.isLogin ?? false { // Что-то сделать если при инициализации авторизация }
            }
        }
    }
}
