//
//  BreathViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.08.2023.
//

import Foundation
import SwiftUI

extension BreathView {
    class ViewModel: ObservableObject {
        
        @Published var viewer: BreathView?
        
        // MARK: - Public
        func setupViewer(_ viewer: BreathView) {
            self.viewer = viewer
        }
        
        func sendBreathCheck() {
            Services.userStateService.postBreathCheck { result in
                switch result {
                case .success:
                    print("Great it sended!")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
