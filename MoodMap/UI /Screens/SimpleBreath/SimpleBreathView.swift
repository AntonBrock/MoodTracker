//
//  SimpleBreathView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 22.11.2023.
//

import SwiftUI
import BottomSheet

struct SimpleBreathView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: SimpleBreathViewCoordinator
        
    // MARK: - Init
    init(
        coordinator: SimpleBreathViewCoordinator
    ) {
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
        
        viewModel.setupViewer(self)
    }
        
    var body: some View {
        VStack {
            JustBreathe {
                // Вызвать метод для дых практики
                dismiss.callAsFunction()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
    
