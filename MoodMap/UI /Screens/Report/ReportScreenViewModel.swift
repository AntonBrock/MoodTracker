//
//  ReportScreenViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import UIKit
import SwiftUI
import HorizonCalendar

extension ReportScreen {
    
    class ViewModel: ObservableObject {
        
        @Published var isEnableTypeOfReprot: [String] = ["Настроение", "Стресс"]
        @Published var isEnableTypeOfReportForRequest: [String] = ["mood", "stress"]

        @Published var reportViewModel: ReportViewModel?
        @Published var emotionCountData: EmotionCountDataViewModel = EmotionCountDataViewModel(
            total: 0,
            common: "",
            text: [],
            color: [],
            countState: [],
            emotionCircleViewModel: []
        )
        
        @Published var firstDayOfWeek: String?
        @Published var lastDayOfWeek: String?
        @Published var currentMonth: String?
        @Published var currentYear: String?
        @Published var isLoading: Bool = false
      
        var selectedTypeOfReport: Int = 0 {
            didSet {
                if dateSelectedIndex == 0 {
                    if selectedTypeOfReport == 0 {
                        getDates()
                    }
                    
                    if selectedTypeOfReport == 1 {
                        getDates()
                    }
                }
                
                if dateSelectedIndex == 1 {
                    didChooseMonthTab()
                }
            }
        }
        
        var dateSelectedIndex: Int = 0 {
            didSet {
                if dateSelectedIndex == 1 {
                    didChooseMonthTab()
                }
                
                if dateSelectedIndex == 0 {
                    getDates()
                }
            }
        }
        
        var shortDateMonthForFrom: String?
        var shortDateMonthForTo: String?
        var currentShortMonthForFrom: String?
        var currentShortMonthForTo: String?
        
        init() {}
        
        func getDates() {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let calendar = Calendar.current
            let fromDate = calendar.date(byAdding: .day, value: -7, to: Date())!
            let toDate = calendar.date(byAdding: .day, value: 0, to: Date())!

            let fromDateString = formatter.string(from: fromDate)
            let toDateString = formatter.string(from: toDate)
            
            setTextInformationDate(fromDate, toDate)
            fetchReport(
                from: fromDateString,
                to: toDateString,
                type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood
            )

//            let isDayInMonthAgoForTheFirstDay = isDayInMonthAgo(day: Int(firstDayOfWeek ?? "") ?? 0)
//
//            if isDayInMonthAgoForTheFirstDay {
//                formatter.dateFormat = "MM"
//                let shortMonth = Calendar.current.date(byAdding: .month,
//                                                       value: -1,
//                                                       to: Date())
//                shortDateMonthForFrom = formatter.string(from: shortMonth!)
//            } else {
//                formatter.dateFormat = "MM"
//                let shortMonth = Calendar.current.date(byAdding: .month,
//                                                       value: 0,
//                                                       to: Date())
//                shortDateMonthForFrom = formatter.string(from: shortMonth!)
//            }
        }
        
        private func setTextInformationDate(_ fromDate: Date, _ toDate: Date) {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MMM"
            self.currentMonth = formatter.string(from: fromDate)
            self.shortDateMonthForFrom = formatter.string(from: fromDate)
            
            formatter.dateFormat = "dd"
            self.firstDayOfWeek = formatter.string(from: fromDate)
            self.lastDayOfWeek = formatter.string(from: toDate)
            
            formatter.dateFormat = "YYYY"
            self.currentYear = formatter.string(from: fromDate)

            formatter.dateFormat = "MM"
            self.currentShortMonthForFrom = formatter.string(from: fromDate)
            self.currentShortMonthForTo = formatter.string(from: toDate)
            
            formatter.dateFormat = "MMM"
            self.shortDateMonthForTo = formatter.string(from: toDate)
        }
        
        private func setTextInformationMonthDate(_ fromDate: Date, _ toDate: Date) {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MMM"
            self.shortDateMonthForTo = formatter.string(from: toDate)
            
            formatter.dateFormat = "MM"
            self.currentShortMonthForTo = formatter.string(from: toDate)
            self.currentShortMonthForTo = formatter.string(from: toDate)
        }
        
        func isDayInMonthAgo(day: Int) -> Bool {
            let calendar = Calendar.current
            let now = Date()
            let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            let components = calendar.dateComponents([.year, .month], from: oneMonthAgo)
            let targetDate = calendar.date(from: components)!.addingTimeInterval(TimeInterval(day * 86400)) // Convert day to seconds
            
            return targetDate >= oneMonthAgo && targetDate < now
        }
        
        func toBeforeWeekDidTap() {
            // от выбранной недели назад на 1 неделю
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let currentDayFrom = "\(currentYear!)-\(currentShortMonthForFrom!)-\(firstDayOfWeek!)"
            let currentDayTo = "\(currentYear!)-\(currentShortMonthForTo!)-\(lastDayOfWeek!)"
            
            guard let dateFrom = formatter.date(from: currentDayFrom) else {
                return
            }
            
            guard let dateTo = formatter.date(from: currentDayTo) else {
                return
            }

            let calendar = Calendar.current
            let oneWeekAgoFrom = calendar.date(byAdding: .day, value: -7, to: dateFrom)!
            let oneWeekAgoTo = calendar.date(byAdding: .day, value: -7, to: dateTo)!

            let oneWeekAgoFromString = formatter.string(from: oneWeekAgoFrom)
            let oneWeekAgoToString = formatter.string(from: oneWeekAgoTo)

            setTextInformationDate(oneWeekAgoFrom, oneWeekAgoTo)
            fetchReport(
                from: oneWeekAgoFromString,
                to: oneWeekAgoToString,
                type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood
            )
        }
        
        func toNextWeekDidTap() {
            // от выбранной недели вперед на 1 неделю
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let currentDayFrom = "\(currentYear!)-\(currentShortMonthForFrom!)-\(firstDayOfWeek!)"
            let currentDayTo = "\(currentYear!)-\(currentShortMonthForTo!)-\(lastDayOfWeek!)"
            
            guard let dateFrom = formatter.date(from: currentDayFrom) else {
                return
            }
            
            guard let dateTo = formatter.date(from: currentDayTo) else {
                return
            }

            let calendar = Calendar.current
            let oneWeekNextFrom = calendar.date(byAdding: .day, value: +7, to: dateFrom)!
            let oneWeekNextTo = calendar.date(byAdding: .day, value: +7, to: dateTo)!

            let oneWeekNextFromString = formatter.string(from: oneWeekNextFrom)
            let oneWeekNextToString = formatter.string(from: oneWeekNextTo)

            setTextInformationDate(oneWeekNextFrom, oneWeekNextTo)
            fetchReport(
                from: oneWeekNextFromString,
                to: oneWeekNextToString,
                type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood
            )
        }
        
        func toBeforeMonthDidTap() {
            // от выбранного месяца назад на 1 месяц
            let currentDayFrom = "\(currentYear!)-\(currentShortMonthForTo!)-01"
            let monthAgo = getDatesForMonthAgo(from: currentDayFrom)

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let monthAgoDateFrom = formatter.date(from: monthAgo?.0 ?? "")!
            let monthAgoDateTo = formatter.date(from: monthAgo?.1 ?? "")!

            setTextInformationMonthDate(monthAgoDateFrom, monthAgoDateTo)
            fetchReport(
                from: monthAgo?.0 ?? "",
                to: monthAgo?.1 ?? "",
                type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood
            )
        }
        
        func toNextMonthDidTap() {
            // от выбранного месяца вперед на 1 месяц
            let currentDayFrom = "\(currentYear!)-\(currentShortMonthForTo!)-01"
            let nextMonth = getDatesForMonthNext(from: currentDayFrom)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let nextMonthDateFrom = formatter.date(from: nextMonth?.0 ?? "")!
            let nextMonthDateTo = formatter.date(from: nextMonth?.1 ?? "")!

            setTextInformationMonthDate(nextMonthDateFrom, nextMonthDateTo)
            fetchReport(
                from: nextMonth?.0 ?? "",
                to: nextMonth?.1 ?? "",
                type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood
            )
        }
        
        private func getDatesForMonthAgo(from dateString: String) -> (String, String)? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let startDate = formatter.date(from: dateString) else {
                return nil // Failed to parse date string
            }
            
            let calendar = Calendar.current
            
            // Subtract one month from the start date
            guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: startDate) else {
                return nil // Failed to subtract one month from start date
            }
            
            // Get the start of the month a month ago
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthAgo))!
            
            // Get the end of the month a month ago
            let startOfNextMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            // Convert dates back to string format
            let startOfMonthString = formatter.string(from: startOfMonth)
            let startOfNextMonthString = formatter.string(from: startOfNextMonth)
            
            return (startOfMonthString, startOfNextMonthString)
        }
        private func getDatesForMonthNext(from dateString: String) -> (String, String)? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let startDate = formatter.date(from: dateString) else {
                return nil // Failed to parse date string
            }
            
            let calendar = Calendar.current
            
            // Subtract one month from the start date
            guard let monthAgo = calendar.date(byAdding: .month, value: +1, to: startDate) else {
                return nil // Failed to subtract one month from start date
            }
            
            // Get the start of the month a month ago
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthAgo))!
            
            // Get the end of the month a month ago
            let startOfNextMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            // Convert dates back to string format
            let startOfMonthString = formatter.string(from: startOfMonth)
            let startOfNextMonthString = formatter.string(from: startOfNextMonth)
            
            return (startOfMonthString, startOfNextMonthString)
        }
        
        func didChooseMonthTab() {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd"
            let theLastDayOfWeek = formatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: Date().endOfMonth)!)

            formatter.dateFormat = "MM"
            let month = formatter.string(from: Calendar.current.date(byAdding: .month, value: 0, to: Date())!)
            
            let from = "\(currentYear!)-\(month)-01"
            let to = "\(currentYear!)-\(month)-\(theLastDayOfWeek)"
            
            fetchReport(
                from: from,
                to: to,
                type: ReportEndPoint.TypeOfReport.init(rawValue: isEnableTypeOfReportForRequest[selectedTypeOfReport]) ?? .mood
            )
        }
        
        func fetchCurrentDate(date: Date,
                              completion: @escaping ([ReportCurrentViewModel]) -> Void) {
//            isLoading = true

            Services.reportService.fetchCurrentDate(date: date) { result in
                switch result {
                case .success(let models):
                    let viewModel = self.mappingCurrentReportViewModel(models: models)
                    completion(viewModel)
                case .failure(let error):
                    print(error)
                }
            }
//            self.isLoading = false
        }
        
        private func fetchReport(from: String, to: String, type: ReportEndPoint.TypeOfReport) {
            isLoading = true

            Services.reportService.fetchReport(from: from, to: to, type: type) { result in
                switch result {
                case .success(let model):
                    self.reportViewModel = self.mappingViewModel(data: model)
                case .failure(let error):
                    print(error)
                }
            }
            
            isLoading = false
            
        }
        
        private func mappingCurrentReportViewModel(models: [ReportCurrentDateModel]) -> [ReportCurrentViewModel] {
            
            var viewModels: [ReportCurrentViewModel] = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            for model in models {
                
                let timeString = dateFormatter.string(from: model.time)
                var activities: [ReportCurrentViewModel.ReportCurrentDateActivitiesViewModel] = []
                model.activities.forEach { model in
                    activities.append(ReportCurrentViewModel.ReportCurrentDateActivitiesViewModel(
                        id: model.id,
                        text: model.text,
                        language: model.language,
                        createdAt: model.createdAt,
                        updatedAt: model.updatedAt,
                        image: model.image,
                        count: model.count ?? 0
                    ))
                }
                
                viewModels.append(ReportCurrentViewModel(stateRate: model.stateRate,
                                                         stressRate: model.stressRate,
                                                         time: timeString,
                                                         activities: activities))
            }
            
           
            return viewModels
        }
        
        private func mappingViewModel(data: ReportModel) -> ReportViewModel {
            let chartData = data.chartData
            let emotionCountData = data.emotionCountData
            let timeData = data.timeData
            let goodActivitiesReportData = data.goodActivitiesReportData
            let badActivitiesReportData = data.badActivitiesReportData
            
            var chartDataViewModel: [ChartDataViewModel] = []
            var emotionCountDataViewModel: EmotionCountDataViewModel?
            var timeDataViewModel: TimeDataViewModel?
            var goodActivitiesReportDataViewModel: GoodActivitiesReportDataViewModel?
            var badActivitiesReportDataViewModel: BadActivitiesReportDataViewModel?
            
            #warning("TODO: Для правильного обновления экрана использовать модели по примеру модели эмоции и главного экрана")
            chartData.forEach { model in
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"

                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd"
                
                if let date = dateFormatterGet.date(from: model.date) {
                    chartDataViewModel.append(ChartDataViewModel(
                        date: dateFormatterPrint.string(from: date),
                        date2: model.date.toDate(.isoDate) ?? Date(),
                        dayRate: model.dayRate,
                        description: model.description.compactMap({ ChartDataViewModel.ChartDataDescriptionViewModel(
                            stateText: $0.stateText,
                            rate: $0.rate,
                            count: $0.count)})
                        )
                    )
                } else {
                   print("There was an error decoding the string")
                }
            }
            
            emotionCountDataViewModel = EmotionCountDataViewModel(
                total: emotionCountData.total,
                common: emotionCountData.common,
                text: emotionCountData.state.map({ $0.text }),
                color: emotionCountData.state.map({ mappingColorForEmotion(with: $0.text)}),
                countState: emotionCountData.state.map({ Double($0.count) })
            )
            
            timeDataViewModel = TimeDataViewModel(
                bestTime: timeData.bestTime,
                worstTime: timeData.worstTime,
                dayParts: timeData.dayParts
            )
            
            goodActivitiesReportDataViewModel = GoodActivitiesReportDataViewModel(
                bestActivity: goodActivitiesReportData.bestActivity,
                activities: goodActivitiesReportData.activities.compactMap({ GoodActivitiesReportDataViewModel.GoodActivitiesReportDataActivitiesViewModel(
                    image: $0.image,
                    count: $0.count
                ) }).sorted(by: { $0.count > $1.count }))
            
            badActivitiesReportDataViewModel = BadActivitiesReportDataViewModel(
                worstActivity: badActivitiesReportData.worstActivity,
                activities: badActivitiesReportData.activities.compactMap({
                    BadActivitiesReportDataViewModel.BadActivitiesReportDataActivitiesViewModel(
                    image: $0.image,
                    count: $0.count
                ) }).sorted(by: { $0.count > $1.count }))
            
            guard let emotionCountDataViewModel = emotionCountDataViewModel,
                  let timeDataViewModel = timeDataViewModel,
                  let goodActivitiesReportDataViewModel = goodActivitiesReportDataViewModel,
                  let badActivitiesReportDataViewModel = badActivitiesReportDataViewModel else { fatalError() }
            
            var emotionalCircleViewModel: [EmotionCircleViewModel] = []
            emotionCountData.state.forEach { item in
                emotionalCircleViewModel.append(EmotionCircleViewModel(
                    name: item.text,
                    value: String(item.count),
                    color: mappingColorForEmotion(with: item.text)))
            }

            self.emotionCountData = emotionCountDataViewModel
            self.emotionCountData.emotionCircleViewModel = emotionalCircleViewModel
            
            return ReportViewModel(
                chartData: chartDataViewModel,
                emotionCountData: emotionCountDataViewModel,
                timeData: timeDataViewModel,
                goodActivitiesReportData: goodActivitiesReportDataViewModel,
                badActivitiesReportData: badActivitiesReportDataViewModel)
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
    }
}

struct ReportViewModel {
    
    let chartData: [ChartDataViewModel]
    var emotionCountData: EmotionCountDataViewModel
    let timeData: TimeDataViewModel
    let goodActivitiesReportData: GoodActivitiesReportDataViewModel
    let badActivitiesReportData: BadActivitiesReportDataViewModel
}

struct ChartDataViewModel: Identifiable {
    
    let id = UUID().uuidString
    let date: String
    let date2: Date
    let dayRate: Int
    let description: [ChartDataDescriptionViewModel]

    struct ChartDataDescriptionViewModel {
        let stateText: String
        let rate: Int
        let count: Int
    }
}

struct EmotionCountDataViewModel: Equatable {
    static func == (lhs: EmotionCountDataViewModel, rhs: EmotionCountDataViewModel) -> Bool {
        return lhs.text == rhs.text
    }
    
    var total: Int
    let common: String
    var text: [String]
    var color: [Color]
    var countState: [Double]
    var emotionCircleViewModel: [EmotionCircleViewModel]?
}

struct TimeDataViewModel {
    let bestTime: String
    let worstTime: String
    let dayParts: String?
}

struct GoodActivitiesReportDataViewModel {
    let bestActivity: String
    let activities: [GoodActivitiesReportDataActivitiesViewModel]
    
    struct GoodActivitiesReportDataActivitiesViewModel {
        let image: String
        let count: Int
    }
}

struct BadActivitiesReportDataViewModel {
    let worstActivity: String
    let activities: [BadActivitiesReportDataActivitiesViewModel]
    
    struct BadActivitiesReportDataActivitiesViewModel {
        let image: String
        let count: Int
    }
}
