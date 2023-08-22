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
        
        @Published var viewer: MainView?
        
        @Published var emotionCountData: EmotionCountDataViewModel = EmotionCountDataViewModel(
            total: 0,
            common: "",
            text: [],
            color: [],
            countState: [],
            emotionCircleViewModel: [],
            dataIsEmpty: true
        )
        
        @Published var timeData: TimeDataViewModel = TimeDataViewModel(
            bestTime: "",
            worstTime: "",
            dayParts: nil,
            dataIsEmpty: true
        )
        
        @Published var journalViewModels: [[JournalViewModel]]?
        
        @Published var isEnableTypeOfReprot: [String] = ["Настроение", "Стресс"]
        @Published var isEnableTypeOfReportForRequest: [String] = ["mood", "stress"]
        @Published var isShowLoader: Bool = false

        var selectedTypeOfReport: Int = 0
        
        var firstDayOfWeek: String?
        var lastDayOfWeek: String?
        var shortDateMonthFrom: String?
        var shortDateMonthTo: String?
        var currentYear: String?
        
        func setupViewer(_ viewer: MainView) {
            self.viewer = viewer
            
            if isNeedUpdateQuote() {
                fetchQuotes()
            } else {
                self.viewer?.quoteText = AppState.shared.quoteText ?? "Это нормально ‒ испытывать плохие эмоции. Это не делает тебя плохим человеком"
            }
            
            fetchMainData()
        }
        
        func isNeedUpdateQuote() -> Bool {
            if let updateQuotesDate = AppState.shared.updateQuotesDate,
               Date().timeIntervalSince(updateQuotesDate) > Constants.timeoutRequestQuotes {
                AppState.shared.updateQuotesDate = Date()
                return true
            } else if AppState.shared.updateQuotesDate == nil {
                AppState.shared.updateQuotesDate = Date()
                return false
            } else { return false }
        }
        
        func fetchQuotes() {
            Services.quotesService.fetchQuote(language: AppState.shared.userLanguage ?? "russian", completion: { result in
                switch result {
                case .success(let quoteModel):
                    AppState.shared.quoteText = quoteModel.text
                    self.viewer?.quoteText = quoteModel.text
                case .failure(let error):
                    print(error)
                }
            })
        }
        
        func fetchMainData() {
            let calendar = Calendar.current
            let date = Date()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let firstDay = Calendar.current.date(byAdding: .day, value: 0, to: Date())
            firstDayOfWeek = formatter.string(from: firstDay!)
           
            let range = calendar.range(of: .day, in: .month, for: date)!
            let lastDayOfMonth = range.count
            
            if calendar.component(.day, from: date) == lastDayOfMonth {
                lastDayOfWeek = "01"
            } else {
                let lastDay = Calendar.current.date(byAdding: .day, value: +1, to: Date())
                lastDayOfWeek = formatter.string(from: lastDay!)
            }
            
            formatter.dateFormat = "MM"
            let shortMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
            shortDateMonthFrom = formatter.string(from: shortMonth!)
            
            if calendar.component(.day, from: date) == lastDayOfMonth {
                let shortMonth = Calendar.current.date(byAdding: .month, value: +1, to: Date())
                shortDateMonthTo = formatter.string(from: shortMonth!)
            } else {
                let shortMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
                shortDateMonthTo = formatter.string(from: shortMonth!)
            }
            
            formatter.dateFormat = "yyyy"
            let year = Calendar.current.date(byAdding: .year, value: 0, to: Date())
            currentYear = formatter.string(from: year!)
            
            let from = "\(currentYear!)-\(shortDateMonthFrom!)-\(firstDayOfWeek!)"
            let to = "\(currentYear!)-\(shortDateMonthTo!)-\(lastDayOfWeek!)"

            if AppState.shared.isLogin ?? false {
                isShowLoader = true
                
                getJournalViewModel(from: from, to: to)
                fetchReport(from: from, to: to,
                            type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood)
            } else {
                clearData()
            }
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
        
        func segmentDidChange() {
            emotionCountData = EmotionCountDataViewModel(
                total: 0,
                common: "",
                text: [],
                color: [],
                countState: [],
                emotionCircleViewModel: [],
                dataIsEmpty: true
            )
            
            fetchMainData()
        }
        
        private func fetchReport(from: String, to: String, type: ReportEndPoint.TypeOfReport) {
            Services.reportService.fetchReport(from: from, to: to, type: type) { result in
                switch result {
                case .success(let model):
                    guard let model = model else {
                        self.clearData()
                        self.isShowLoader = false
                        return
                    }
                    self.emotionCountData = self.mappingEmotionCountData(data: model)
                    self.timeData = self.mappingTimeData(data: model)
                    self.isShowLoader = false
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        private func clearData() {
            emotionCountData = EmotionCountDataViewModel(
                total: 0,
                common: "",
                text: [],
                color: [],
                countState: [],
                emotionCircleViewModel: [],
                dataIsEmpty: true
            )
            
            timeData = TimeDataViewModel(
                bestTime: "",
                worstTime: "",
                dayParts: nil,
                dataIsEmpty: true
            )
            
            journalViewModels = []
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
                    activities: i.activities.map({ ActivitiesViewModel(
                        id: $0.id,
                        text: $0.text,
                        language: $0.language,
                        image: $0.image,
                        created_at: nil,
                        updated_at: nil
                    )}),
                    color: self.getColors(with: self.getState(from: i.stateId)),
                    stateImage: self.getStateImage(from: i.stateId),
                    emotionImage: self.getEmotionImage(from: i.emotionId),
                    stressRate: i.stressRate,
                    text: i.text ?? "",
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
                countState: emotionCountData.state.compactMap({ Double($0.count) }).sorted(by: { $0 > $1 }),
                dataIsEmpty: emotionCountData.total == 0 ? true : false
            )
            
            guard var emotionCountDataViewModel = emotionCountDataViewModel else { fatalError() }
            
            var emotionalCircleViewModel: [EmotionCircleViewModel] = []
            emotionCountData.state.forEach { item in
                emotionalCircleViewModel.append(EmotionCircleViewModel(
                    name: item.text,
                    value: String(item.count),
                    color: selectedTypeOfReport == 1 ? mappingColorForEmotionStress(with: item.text) : mappingColorForEmotion(with: item.text)))
            }

            self.emotionCountData = emotionCountDataViewModel
            emotionCountDataViewModel.emotionCircleViewModel = emotionalCircleViewModel

            return emotionCountDataViewModel
        }
        
        private func mappingTimeData(data: ReportModel) -> TimeDataViewModel {
            let timeData = data.timeData
            var timeDataViewModel: TimeDataViewModel?

            let dayParts: [DayParts] = getDayParts(model: timeData.dayParts)

            timeDataViewModel = TimeDataViewModel(
                bestTime: timeData.bestTime,
                worstTime: timeData.worstTime,
                dayParts: dayParts,
                dataIsEmpty: dayParts.isEmpty
            )
            
            guard let timeDataViewModel = timeDataViewModel else { fatalError() }
            return timeDataViewModel
        }
        
        private func mappingColorForEmotionStress(with stressTitle: String) -> Color {
            switch stressTitle {
            case "Низкий": return Colors.Secondary.riptide500Green
            case "Средний": return Colors.Primary.lavender500Purple
            case "Высокий": return Colors.Secondary.yourPinkRed400
            default: return Color.white
            }
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
            let timeDate = formatter.string(from: time)
            
            if let timeDate = formatter.date(from: timeDate) {
                formatter.dateFormat = format
                formatter.locale = Locale(identifier: "ru_RU") // Тут настройка от потом языка!
                return formatter.string(from: timeDate)
            } else {
                return ""
            }
        }
        
        private func getDayParts(model: [ReportModel.TimeData.DayParts]) -> [DayParts] {
            var dayParts: [DayParts] = []
            
            model.forEach { model in
                switch model.time {
                case "morning":
                    dayParts.append(DayParts(time: "Утро", text: model.text ?? "Неизвестно"))
                case "afternoon":
                    dayParts.append(DayParts(time: "День", text: model.text ?? "Неизвестно"))
                case "evening":
                    dayParts.append(DayParts(time: "Вечер", text: model.text ?? "Неизвестно"))
                case "night":
                    dayParts.append(DayParts(time: "Ночь", text: model.text ?? "Неизвестно"))
                default: return
                }
            }
            
            return dayParts
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
