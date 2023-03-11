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
            getJournalViewModel()
        }
        
        func getJournalViewModel() {
            Services.journalService.getUserNotes { result in
                switch result {
                case .success(let models):
                    self.journalViewModels = models.map({ JournalViewModel(
                        id: $0.id,
                        state: .fine,
                        title: $0.emotionId,
                        activities: $0.activities.map({ ActivitiesViewModel(id: $0.id,
                                                                            text: $0.text,
                                                                            language: $0.language,
                                                                            image: $0.image)}),
                        color: self.getColors(with: .fine),
                        emotionImage: "ch-ic-fine",
                        time: $0.createdAt)
                    })
                case .failure(let error):
                    print(error)
                }
            }
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
    
    let id: String
    let state: State
    let title: String
    let activities: [ActivitiesViewModel]
    let color: [Color]
    let emotionImage: String
    let time: String
}
