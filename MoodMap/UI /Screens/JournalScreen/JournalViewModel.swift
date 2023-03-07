//
//  JournalViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import Foundation
import SwiftUI

extension JournalView {
    class ViewModel: ObservableObject {
        
        var journalViewModels: [JournalViewModel]?
        
        init() {
            journalViewModels = getJournalViewModel()
        }
        
        func getJournalViewModel() -> [JournalViewModel] {
            return [
                JournalViewModel(
                    id: 0,
                    state: .fine,
                    title: getTitle(with: .fine),
                    activities: ["Свидание", "Еда"],
                    color: getColors(with: .fine),
                    emotionImage: "ch-ic-fine",
                    time: "12:20"
                )
            ]
        }
        
        private func getTitle(with state: JournalViewModel.State) -> String {
            switch state {
            case .diary: return "Дневник благодарности"
            case .veryBad: return "Очень плохо"
            case .bad: return "Плохо"
            case .fine: return "Нормально"
            case .good: return "Хорошо"
            case .veryGood: return "Очень хорошо"
            }
        }
        
        private func getColors(with state: JournalViewModel.State) -> [Color] {
            switch state {
            case .diary: return [Colors.Secondary.shamrock600Green]
            case .veryBad: return [Colors.Secondary.cruise400Green, Colors.Secondary.cruise400Green]
            case .bad: return [Colors.Secondary.cruise400Green, Colors.Secondary.cruise400Green]
            case .fine: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .good: return [Colors.Secondary.cruise400Green, Colors.Secondary.cruise400Green]
            case .veryGood: return [Colors.Secondary.cruise400Green, Colors.Secondary.cruise400Green]
            }
        }
    }
}

struct JournalViewModel {
    enum State {
        case diary
        case veryBad
        case bad
        case fine
        case good
        case veryGood
    }
    
    let id: Int
    let state: State
    let title: String
    let activities: [String]
    let color: [Color]
    let emotionImage: String
    let time: String
}
