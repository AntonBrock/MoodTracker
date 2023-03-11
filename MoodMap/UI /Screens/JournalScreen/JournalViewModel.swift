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
                        state: self.getState(from: $0.stateId),
                        title: self.getTitle(with: self.getState(from: $0.stateId)),
                        activities: $0.activities.map({ ActivitiesViewModel(id: $0.id,
                                                                            text: $0.text,
                                                                            language: $0.language,
                                                                            image: $0.image)}),
                        color: self.getColors(with: self.getState(from: $0.stateId)),
                        stateImage: self.getStateImage(from: $0.stateId),
                        emotionImage: self.getEmotionImage(from: $0.emotionId),
                        stressRate: $0.stressRate,
                        text: $0.text,
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
        
        private func getState(from stringState: String) -> JournalViewModel.State {
            switch stringState {
            case "3d07a86f-0b8a-481c-913f-88503d10c8a2": return .veryBad
            case "b6bdf4d7-dc62-49e4-967e-6855f72c229b": return .bad
            case "45be90af-0404-42dd-8bbe-66d67787840f": return .fine
            case "cb79441e-23ef-4e4c-be08-c8ba293d700d": return .good
            case "85306de6-18d4-4b9f-aef4-cb41ffe31619": return .veryGood
            default: return .fine
            }
        }
        
        private func getStateImage(from stringUserState: String) -> String {
            switch stringUserState {
            case "3d07a86f-0b8a-481c-913f-88503d10c8a2": return "ch-ic-veryBad"
            case "b6bdf4d7-dc62-49e4-967e-6855f72c229b": return "ch-ic-sad"
            case "45be90af-0404-42dd-8bbe-66d67787840f": return "ch-ic-fine"
            case "cb79441e-23ef-4e4c-be08-c8ba293d700d": return "ch-ic-good"
            case "85306de6-18d4-4b9f-aef4-cb41ffe31619": return "ch-ic-veryGood"
            default: return "ch-ic-fine"
            }
        }
        
        #warning("TODO: Нужно переделать ручку и возвращать массив! А так же название выбранных картинк эмоций от бэка")
        private func getEmotionImage(from emotionId: String) -> String {
            return "em-f-exhalingFace"
        }
        
        private func getColors(with state: JournalViewModel.State) -> [Color] {
            switch state {
            case .diary: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .veryBad: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .bad: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .fine: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .good: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .veryGood: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
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
    let stateImage: String
    let emotionImage: String
    let stressRate: Int
    let text: String
    let time: String
}
