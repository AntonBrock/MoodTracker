//
//  DiaryViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 02.04.2023.
//

import Foundation
import SwiftUI

extension DiaryView {
    
    class ViewModel: ObservableObject {
        
        @Published var diaryViewModel: [DiaryViewModel]?
        @Published var isShowLoader: Bool = false
        
        init() {
            getDiary()
        }
        
        func getDiary() {
            isShowLoader = true
            
            Services.diaryService.fetchDiary { result in
                switch result {
                case .success(let models):
                    self.diaryViewModel = self.mappingViewModel(data: models)
                    self.isShowLoader = false
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func sendNewDiaryPage(with text: String) {
            Services.diaryService.setNewDiaryPage(page: text) { result in
                switch result {
                case .success(let model):
                    Services.metricsService.sendEventWith(eventName: .saveNewDiaryPageButton)
                    Services.metricsService.sendEventWith(eventType: .saveNewDiaryPageButton)

                    self.diaryViewModel?.insert(self.mappingSingleViewModel(data: model), at: 0)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        private func mappingViewModel(data: [DiaryModel]) -> [DiaryViewModel] {
            var viewModel: [DiaryViewModel] = []
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            formatter.locale = Locale(identifier: "ru_RU")
            
            for item in data {
                let message = item.diaryPage
                let id = item.id
                var stringDate: String = ""
                
                if let timeDate = formatter.date(from: item.createdAt) {
                    formatter.dateFormat = "dd MMMM yyyy, в HH:mm"
                    formatter.locale = Locale(identifier: "ru_RU")
                    stringDate = formatter.string(from: timeDate)
                }
                
                viewModel.append(DiaryViewModel(id: id, message: message, createdAt: stringDate))
            }
            
            return viewModel.sorted(by: { $0.createdAt < $1.createdAt })
        }
        
        private func mappingSingleViewModel(data: DiaryModel) -> DiaryViewModel {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = TimeZone(identifier: "UTC")
            
            var stringDate: String = ""
            if let timeDate = formatter.date(from: data.createdAt) {
                formatter.dateFormat = "dd MMMM YYYY HH:MM"
                formatter.locale = Locale(identifier: "ru_RU") // Тут настройка от потом языка!
                stringDate = formatter.string(from: timeDate)
            }
            
            return DiaryViewModel(id: data.id, message: data.diaryPage, createdAt: stringDate)
        }
    }
}

// MARK: - DiaryViewModel
struct DiaryViewModel: Hashable {
    static func == (lhs: DiaryViewModel, rhs: DiaryViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    let id: String
    let message: String
    let createdAt: String
}
