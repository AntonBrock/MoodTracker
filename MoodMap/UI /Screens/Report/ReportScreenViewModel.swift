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
        var shortDateMonth: String?
        @Published var currentYear: String?
        
        @Published var isLoading: Bool = false
        
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
        
        func fetchCurrentDate(date: Date, completion: @escaping ([ReportCurrentViewModel]) -> Void) {
            isLoading = true

            Services.reportService.fetchCurrentDate(date: date, type: .mood) { result in
                switch result {
                case .success(let models):
                    let viewModel = self.mappingCurrentReportViewModel(models: models)
                    completion(viewModel)
                    
                    self.isLoading = false
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        private func fetchReport(from: String, to: String) {
            isLoading = true

            Services.reportService.fetchReport(from: from, to: to, type: .mood) { result in
                switch result {
                case .success(let model):
                    self.reportViewModel = self.mappingViewModel(data: model)
                    self.isLoading = false
                case .failure(let error):
                    print(error)
                }
            }
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
                chartData: chartDataViewModel.sorted(by: { $0.date < $1.date }),
                emotionCountData: emotionCountDataViewModel,
                timeData: timeDataViewModel,
                goodActivitiesReportData: goodActivitiesReportDataViewModel,
                badActivitiesReportData: badActivitiesReportDataViewModel)
        }
        
        private func mappingColorForEmotion(with emotionTitle: String) -> Color {
            switch emotionTitle {
            case "Oчень плохо": return Color(hex: "F5DADA")
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
