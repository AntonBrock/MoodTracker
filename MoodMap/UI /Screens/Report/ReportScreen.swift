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
                        WeekAnimationChart()
                    } else {
                        MonthChart()
                    }
                } else {
                    NavigationView {
                        VStack {
                            List {
                                Section(header: Text("1")) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            HStack(spacing: 16) {
                                                ZStack {
                                                    VStack{}
                                                        .background(
                                                            Circle()
                                                                .fill(.blue)
                                                                .frame(width: 50, height: 50)
                                                            
                                                        )
                                                    VStack{}
                                                        .background(
                                                            ZStack {
                                                                Circle()
                                                                    .fill(.white)
                                                                    .frame(width: 24, height: 24)
                                                                
                                                                Circle()
                                                                    .fill(.red)
                                                                    .frame(width: 20, height: 20)
                                                            }
                                                            
                                                            
                                                        )
                                                        .padding(.top, 26)
                                                        .padding(.leading, 26)
                                                }
                                                .frame(width: 50, height: 50)
                                                .padding(.leading, 5)
                                                .padding(.vertical, 9)
                                            }
                                            
                                            VStack(spacing: 6) {
                                                VStack {
                                                    Text("Хобби")
                                                        .font(.system(size: 16, weight: .regular))
                                                        .foregroundColor(Colors.Primary.blue)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                HStack(spacing: 12) {
                                                    Text("Вдохновляет")
                                                        .font(.system(size: 11, weight: .regular))
                                                        .foregroundColor(Colors.Primary.blue)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Text("Тревожит")
                                                        .font(.system(size: 11, weight: .regular))
                                                        .foregroundColor(Colors.Primary.blue)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading, 16)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Spacer()
                                            
                                            Text("7")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white)
                                            //                                        .padding()
                                                .background(
                                                    Circle()
                                                        .fill(Colors.Secondary.shamrock600Green)
                                                        .frame(width: 24, height: 24)
                                                )
                                        }
                                        
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(
                                        Color.white
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .shadow(color: Colors.TextColors.cadetBlue600.opacity(0.5), radius: 5)
                                    )
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }

                ReportTipView()
                
                CircleEmotionChart()
                
                ReportTipView()
               
                DayilyCharts()
                
                ReportTipView()
                
                ActivitiesCharts()
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
