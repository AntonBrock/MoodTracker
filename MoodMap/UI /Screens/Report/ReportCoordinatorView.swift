//
//  ReportCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

struct ReportCoordinatorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var coordinator: ReportViewCoordinator
    @State var currentDate: Date = Date()
    
    var body: some View {        
        NavigationStack {
            ReportScreen(coordinator: coordinator, wasOpenedFromTabBar: {
                Services.metricsService.sendEventWith(eventName: .openReportScreen)
                Services.metricsService.sendEventWith(eventType: .openReportScreen)

            })
            .navigationTitle("Отчет")
            .toolbarBackground(
                colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white,
                for: .navigationBar
            )
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
