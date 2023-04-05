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
            countState: []
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
            }
        }
        
        var shortDateMonthForFrom: String?
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
            
            formatter.dateFormat = "MM"
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
//                    self.isLoading = false
                case .failure(let error):
                    print(error)
                }
            }
            
            self.isLoading = false // Пока что тут сделаем, но потом нужно на компонент графика - добавить плашку что данных нет!
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
                text: emotionCountData.state.compactMap({ $0.text }),
                color: emotionCountData.state.compactMap({ mappingColorForEmotion(with: $0.text)}),
                countState: emotionCountData.state.compactMap({ Double($0.count) }).sorted(by: { $0 > $1 })
                
//                state: emotionCountData.state.compactMap({ EmotionCountDataViewModel.EmotionCountDataStateViewModel(
//                    text: $0.text,
//                    countState: Double($0.count),
//                    color: mappingColorForEmotion(with: $0.text)
            )
//            .sorted(by: { $0.countState > $1.countState })
//            )
            
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
            
            self.emotionCountData = emotionCountDataViewModel
            
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
    var total: Int
    let common: String
//    var state: [EmotionCountDataStateViewModel]
    var text: [String]
    var color: [Color]
    var countState: [Double]

//    struct EmotionCountDataStateViewModel: Equatable {
//        let text: String
//        var countState: Double
//        let color: String
//    }
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
