//
//  ReportCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

struct ReportCoordinatorView: View {
    
    @ObservedObject var coordinator: ReportViewCoordinator
    @State var currentDate: Date = Date()
    
    var body: some View {        
        NavigationView {
            ReportScreen(coordinator: coordinator, wasOpenedFromTabBar: {
                Services.metricsService.sendEventWith(eventName: .openReportScreen)
            })
                .navigationTitle("Отчет")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
