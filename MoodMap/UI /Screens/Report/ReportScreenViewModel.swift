//
//  ReportScreenViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation
import UIKit

extension ReportScreen {
    
    class ViewModel: ObservableObject {
        
        @Published var reportViewModel: ReportViewModel?

        init() {
            fetchReport()
        }
        
        private func fetchReport() {
            Services.reportService.fetchReport { result in
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
                chartDataViewModel.append(ChartDataViewModel(
                    date: model.date,
                    dayRate: model.dayRate,
                    description: model.description.compactMap({ ChartDataViewModel.ChartDataDescriptionViewModel(
                        stateText: $0.stateText,
                        rate: $0.rate,
                        count: $0.count)}))
                )
                
            }
            
            emotionCountDataViewModel = EmotionCountDataViewModel(
                total: emotionCountData.total,
                common: emotionCountData.common,
                state: emotionCountData.state.compactMap({ EmotionCountDataViewModel.EmotionCountDataStateViewModel(
                    text: $0.text,
                    count: $0.count)})
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
                ) }))
            
            badActivitiesReportDataViewModel = BadActivitiesReportDataViewModel(
                worstActivity: badActivitiesReportData.worstActivity,
                activities: badActivitiesReportData.activities.compactMap({
                    BadActivitiesReportDataViewModel.BadActivitiesReportDataActivitiesViewModel(
                    image: $0.image,
                    count: $0.count
                ) }))
            
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
    let dayRate: Int
    let description: [ChartDataDescriptionViewModel]

    struct ChartDataDescriptionViewModel {
        let stateText: String
        let rate: Int
        let count: Int
    }
}

struct EmotionCountDataViewModel {
    let total: Int
    let common: String
    let state: [EmotionCountDataStateViewModel]
    
    struct EmotionCountDataStateViewModel {
        let text: String
        let count: Int
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
