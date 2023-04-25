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
        
        @Published var journalViewModels: [[JournalViewModel]]?
        @Published var sharingJournalViewModel: JournalViewModel?
        @Published var isShowLoader: Bool = false
        
        init() {
            if AppState.shared.isLogin ?? false {
                getJournalViewModel()
            }
        }
        
        func getJournalViewModel() {
            isShowLoader = true
            
            if AppState.shared.isLogin ?? false {
                Services.journalService.getUserNotes { result in
                    switch result {
                    case .success(let models):
                        self.journalViewModels = self.mappingViewModel(data: models)
                        self.isShowLoader = false
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        func getJournalViewModel(from: String, to: String) {
            if AppState.shared.isLogin ?? false {
                isShowLoader = true
                Services.journalService.getUserNotesWithDate(from: from, to: to) { result in
                    switch result {
                    case .success(let models):
                        self.journalViewModels?.removeAll()
                        self.journalViewModels = self.mappingViewModel(data: models)
                        self.isShowLoader = false
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        private func mappingViewModel(data: [JournalModel]) -> [[JournalViewModel]] {
            var models: [JournalViewModel] = []
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "MMM dd"
                                    
            for i in data {
                models.append(JournalViewModel(
                    id: i.id,
                    state: self.getState(from: i.stateId),
                    title: self.getTitle(with: self.getState(from: i.stateId)),
                    activities: i.activities.map({ ActivitiesViewModel(id: $0.id,
                                                                       text: $0.text,
                                                                       language: $0.language,
                                                                       image: $0.image)}),
                    color: self.getColors(with: self.getState(from: i.stateId)),
                    stateImage: self.getStateImage(from: i.stateId),
                    emotionImage: self.getEmotionImage(from: i.emotionId),
                    stressRate: i.stressRate,
                    text: i.text,
                    monthTime: self.getFormatterTime(with: i.createdAt, and: "MMM dd"),
                    month: self.getFormatterTime(with: i.createdAt, and: "MMM"),
                    monthCurrentTime: self.getFormatterTime(with: i.createdAt, and: "dd"),
                    shortTime: self.getFormatterTime(with: i.createdAt, and: "HH:mm"),
                    longTime: self.getFormatterTime(with: i.createdAt, and: "dd MMM yyyy, HH:mm")))
            }
            
            let sortedModels = models.sorted(by: { $0.longTime > $1.longTime })
            let modelGroups = Array(Dictionary(grouping: sortedModels){ $0.monthTime }.values)
            let sortedGroupsModel = modelGroups.sorted(by: { $0[0].month < $1[0].month })
            
            return sortedGroupsModel
        }
        
        private func getFormatterTime(with time: Date,
                                      and format: String) -> String {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(identifier: "UTC")
            let timeDate = formatter.string(from: time)
            
            if let timeDate = formatter.date(from: timeDate) {
                formatter.dateFormat = format
                formatter.locale = Locale(identifier: "ru_RU") // Тут настройка от потом языка!
                return formatter.string(from: timeDate)
            } else {
                return ""
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
            case .veryBad: return [Color(hex: "FFC8C8"), Color(hex: "F95555")]
            case .bad: return [Color(hex: "7392FC"), Color(hex: "7137AF")]
            case .fine: return [Color(hex: "BBBAFF"), Color(hex: "973FF4")]
            case .good: return [Color(hex: "86E9C5"), Color(hex: "11AADF")]
            case .veryGood: return [Color(hex: "FFC8C8"), Color(hex: "FFC794")]
            }
        }
    }
}

// MARK: - JournalViewModel
struct JournalViewModel: Hashable {
    static func == (lhs: JournalViewModel, rhs: JournalViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    enum State {
        case diary
        case veryBad
        case bad
        case fine
        case good
        case veryGood
    }
    
    let identifier: String = UUID().uuidString
    let id: String
    let state: State
    let title: String
    let activities: [ActivitiesViewModel]
    let color: [Color]
    let stateImage: String
    let emotionImage: String
    let stressRate: String
    let text: String
    let monthTime: String
    let month: String
    let monthCurrentTime: String
    let shortTime: String
    let longTime: String
}
