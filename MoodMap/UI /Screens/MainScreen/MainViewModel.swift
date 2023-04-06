//
//  MainViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.04.2023.
//

import Foundation
import SwiftUI

extension MainView {
    class ViewModel: ObservableObject {
        
        @Published var emotionCountData: EmotionCountDataViewModel = EmotionCountDataViewModel(
            total: 0,
            common: "",
            text: [],
            color: [],
            countState: [],
            emotionCircleViewModel: []
        )
        
        @Published var timeData: TimeDataViewModel?
        @Published var journalViewModels: [[JournalViewModel]]?
        
        @Published var isEnableTypeOfReprot: [String] = ["Настроение", "Стресс"]
        @Published var isEnableTypeOfReportForRequest: [String] = ["mood", "stress"]
        var selectedTypeOfReport: Int = 0
        
        var firstDayOfWeek: String?
        var lastDayOfWeek: String?
        var shortDateMonth: String?
        var currentYear: String?

        init() {
            fetchMainData()
        }
        
        func fetchMainData() {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let firstDay = Calendar.current.date(byAdding: .day, value: 0, to: Date())
            firstDayOfWeek = formatter.string(from: firstDay!)
           
            let lastDay = Calendar.current.date(byAdding: .day, value: +1, to: Date())
            lastDayOfWeek = formatter.string(from: lastDay!)
            
            formatter.dateFormat = "MM"
            let shortMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
            shortDateMonth = formatter.string(from: shortMonth!)
            
            formatter.dateFormat = "yyyy"
            let year = Calendar.current.date(byAdding: .year, value: 0, to: Date())
            currentYear = formatter.string(from: year!)
            
            let from = "\(currentYear!)-\(shortDateMonth!)-\(firstDayOfWeek!)"
            let to = "\(currentYear!)-\(shortDateMonth!)-\(lastDayOfWeek!)"

            getJournalViewModel(from: from, to: to)
            fetchReport(from: from, to: to, type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood)
        }
        
        func getJournalViewModel(from: String, to: String) {
            Services.journalService.getUserNotesWithDate(from: from, to: to) { result in
                switch result {
                case .success(let models):
                    self.journalViewModels?.removeAll()
                    self.journalViewModels = self.mappingViewModel(data: models)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        private func fetchReport(from: String, to: String, type: ReportEndPoint.TypeOfReport) {
            Services.reportService.fetchReport(from: from, to: to, type: type) { result in
                switch result {
                case .success(let model):
                    self.emotionCountData = self.mappingEmotionCountData(data: model)
                    self.timeData = self.mappingTimeData(data: model)
                case .failure(let error):
                    print(error)
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
        
        private func mappingEmotionCountData(data: ReportModel) -> EmotionCountDataViewModel {
            let emotionCountData = data.emotionCountData
            var emotionCountDataViewModel: EmotionCountDataViewModel?
            
            emotionCountDataViewModel = EmotionCountDataViewModel(
                total: emotionCountData.total,
                common: emotionCountData.common,
                text: emotionCountData.state.compactMap({ $0.text }),
                color: emotionCountData.state.compactMap({ mappingColorForEmotion(with: $0.text)}),
                countState: emotionCountData.state.compactMap({ Double($0.count) }).sorted(by: { $0 > $1 })
            )
            
            guard var emotionCountDataViewModel = emotionCountDataViewModel else { fatalError() }
            
            var emotionalCircleViewModel: [EmotionCircleViewModel] = []
            emotionCountData.state.forEach { item in
                emotionalCircleViewModel.append(EmotionCircleViewModel(
                    name: item.text,
                    value: String(item.count),
                    color: mappingColorForEmotion(with: item.text)))
            }

            self.emotionCountData = emotionCountDataViewModel
            emotionCountDataViewModel.emotionCircleViewModel = emotionalCircleViewModel

            return emotionCountDataViewModel
        }
        
        private func mappingTimeData(data: ReportModel) -> TimeDataViewModel {
            let timeData = data.timeData
            var timeDataViewModel: TimeDataViewModel?

            timeDataViewModel = TimeDataViewModel(
                bestTime: timeData.bestTime,
                worstTime: timeData.worstTime,
                dayParts: timeData.dayParts
            )
            
            guard let timeDataViewModel = timeDataViewModel else { fatalError() }
            
            return timeDataViewModel
        }
    
        private func mappingColorForEmotion(with emotionTitle: String) -> Color {
            switch emotionTitle {
            case "Очень плохо": return Color(hex: "F5DADA")
            case "Плохо": return Color(hex: "B9C8FD")
            case "Нормально": return Color(hex: "B283E4")
            case "Хорошо": return Color(hex: "86E9C5")
            case "Очень хорошо": return Color(hex: "FFC794")
            default: return Color.white
            }
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
