//
//  ReportScreenViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import UIKit
import HorizonCalendar

extension ReportScreen {
    
    class ViewModel: ObservableObject {
        
        @Published var reportViewModel: ReportViewModel?
        @Published var firstDayOfWeek: String?
        @Published var lastDayOfWeek: String?
        @Published var currentMonth: String?
        var shortDateMonth: String?
        @Published var currentYear: String?

        init() {}
        
        func getDates() {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let firstDay = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            firstDayOfWeek = formatter.string(from: firstDay!)
           
            let lastDay = Calendar.current.date(byAdding: .day, value: 0, to: Date())
            lastDayOfWeek = formatter.string(from: lastDay!)
            
            formatter.dateFormat = "MMM"
            let mounth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
            currentMonth = formatter.string(from: mounth!)
            
            formatter.dateFormat = "MM"
            let shortMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
            shortDateMonth = formatter.string(from: shortMonth!)
            
            formatter.dateFormat = "yyyy"
            let year = Calendar.current.date(byAdding: .year, value: 0, to: Date())
            currentYear = formatter.string(from: year!)
            
            let from = "\(currentYear!)-\(shortDateMonth!)-\(firstDayOfWeek!)"
            let to = "\(currentYear!)-\(shortDateMonth!)-\(lastDayOfWeek!)"

            fetchReport(from: from, to: to)
        }
        
        func toBeforeWeekDidTap() {
            // от выбранной недели назад на 1 неделю
            
            let from = "\(currentYear!)-\(shortDateMonth!)-\(firstDayOfWeek!)"
            let to = "\(currentYear!)-\(shortDateMonth!)-\(lastDayOfWeek!)"

            fetchReport(from: from, to: to)
        }
        
        func toNextWeekDidTap() {
            // от выбранной недели вперед на 1 неделю
            
            
            let from = "\(currentYear!)-\(shortDateMonth!)-\(firstDayOfWeek!)"
            let to = "\(currentYear!)-\(shortDateMonth!)-\(lastDayOfWeek!)"

            fetchReport(from: from, to: to)
        }
        
        func didChooseMonthTab() {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd"
            let theLastDayOfWeek = formatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: Date().endOfMonth)!)

            formatter.dateFormat = "MM"
            let month = formatter.string(from: Calendar.current.date(byAdding: .month, value: 0, to: Date())!)
            
            
            let from = "\(currentYear!)-\(month)-01"
            let to = "\(currentYear!)-\(month)-\(theLastDayOfWeek)"
            
            fetchReport(from: from, to: to)
        }
        
        private func fetchReport(from: String, to: String) {
            Services.reportService.fetchReport(from: from, to: to) { result in
                switch result {
                case .success(let model):
                    self.reportViewModel = self.mappingViewModel(data: model)
                    
                case .failure(let error):
                    print(error)
                }
            }
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
                            count: $0.count)}))
                    )
                } else {
                   print("There was an error decoding the string")
                }
                
            }
            
            emotionCountDataViewModel = EmotionCountDataViewModel(
                total: emotionCountData.total,
                common: emotionCountData.common,
                state: emotionCountData.state.compactMap({ EmotionCountDataViewModel.EmotionCountDataStateViewModel(
                    text: $0.text,
                    count: $0.count,
                    color: mappingColorForEmotion(with: $0.text)
                )})
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
            
            return ReportViewModel(
                chartData: chartDataViewModel,
                emotionCountData: emotionCountDataViewModel,
                timeData: timeDataViewModel,
                goodActivitiesReportData: goodActivitiesReportDataViewModel,
                badActivitiesReportData: badActivitiesReportDataViewModel)
        }
        
        private func mappingColorForEmotion(with emotionTitle: String) -> String {
            switch emotionTitle {
            case "Good", "Хорошо": return "FFC794"
            case "Bad", "Плохо": return "B9C8FD"
            default: return "B283E4"
            }
        }
    }
}

struct ReportViewModel {
    
    let chartData: [ChartDataViewModel]
    let emotionCountData: EmotionCountDataViewModel
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
    let total: Int
    let common: String
    let state: [EmotionCountDataStateViewModel]
    
    struct EmotionCountDataStateViewModel: Equatable {
        let text: String
        let count: Int
        let color: String
    }
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
