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
            countState: []
        )
        @Published var timeData: TimeDataViewModel?
        
        var firstDayOfWeek: String?
        var lastDayOfWeek: String?
        var shortDateMonth: String?
        var currentYear: String?

        init() {
            getTodayDates()
        }
        
        
        func getTodayDates() {
            
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

            fetchReport(from: from, to: to)
        }
        
        private func fetchReport(from: String, to: String) {
            Services.reportService.fetchReport(from: from, to: to) { result in
                switch result {
                case .success(let model):
                    self.emotionCountData = self.mappingEmotionCountData(data: model)
                    self.timeData = self.mappingTimeData(data: model)

                case .failure(let error):
                    print(error)
                }
            }
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
            
            guard let emotionCountDataViewModel = emotionCountDataViewModel else { fatalError() }

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
