//
//  ReportScreenViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 15.03.2023.
//

import Foundation

extension ReportScreen {
    class ViewModel: ObservableObject {
                
        init() {
            fetchReport()
        }
        
        private func fetchReport() {
            Services.reportService.fetchReport()
        }
    }
}
