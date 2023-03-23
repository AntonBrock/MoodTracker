//
//  ReportScreen.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 09.10.2022.
//

import SwiftUI
import SwiftUICharts
import Charts

struct ReportScreen: View {
    
    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: ReportViewCoordinator
    
    @State var typeSelectedIndex: Int = 0
    @State var dateSelectedIndex: Int = 0
    
    var typeTitles: [String] = ["Настроение", "Стресс", "События"]
    var dateTitles: [String] = ["Неделя", "Месяц", "Все время"]
    
//    @State var sampleAnalytics: [SiteView] = sample_analytics
//    @State var monthDate: [TaskMetaData] = tasks
//    @State var currentPlot = ""
//    @State var offset: CGSize = CGSize(width: 100, height: 200)
//    @State var showPlot = false
//    @State var showDaylyMonthDetails: Bool = false
//    @State var translation: CGFloat = 0
    
//    @State var currentDate: Date = Date()
//    @State var currentMonth: Int = 0
    
    init(
        coordinator: ReportViewCoordinator
    ){
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                SegmentedControlView(countOfItems: 3, segments: typeTitles,
                                     selectedIndex: $typeSelectedIndex,
                                     currentTab: typeTitles[0])
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                SegmentedControlView(countOfItems: 2, segments: dateTitles,
                                     selectedIndex: $dateSelectedIndex,
                                     currentTab: dateTitles[0])
                    .padding(.top, 10)
                    .padding(.horizontal, 16)

                
                if typeSelectedIndex == 0 || typeSelectedIndex == 1 {
                    if dateSelectedIndex == 0 {
                        WeekAnimationChart(weekChartViewModel: viewModel.reportViewModel?.chartData ?? [])
                    } else {
                        MonthChart()
                    }
                    
                    CircleEmotionChart(emotionViewModel: viewModel.reportViewModel?.emotionCountData)
                    
                    ReportTipView(text: "")
                   
                    DayilyCharts(viewModel: viewModel.reportViewModel?.timeData)
                    
                    ReportTipView(text: "")
                    
                    ActivitiesCharts(goodActivitiesViewModel: viewModel.reportViewModel?.goodActivitiesReportData,
                                     badActivitiesViewModel: viewModel.reportViewModel?.badActivitiesReportData)
                } else {
                    ActivitiesChartsForAllTime()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: dateSelectedIndex) { newValue in
            
//            sampleAnalytics = sample_analytics
//            if dateSelectedIndex != 0 {
//                for (index, _) in sampleAnalytics.enumerated() {
//                    sampleAnalytics[index].views = .random(in: 1500...10000)
//                }
//            }
//
//            animateGraph(fromChange: true)
        }
    }
}


// MARK: - For CalendarData

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
