//
//  ReportScreen.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 09.10.2022.
//

import SwiftUI
import SwiftUICharts
import Charts
import HorizonCalendar

struct ReportScreen: View {
    
    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: ReportViewCoordinator
        
    @State var choosedDate: Date = Date()
    @State var showDatePicker: Bool = false
    @State var isChoosindNewDate: Bool = false
        
    @State var selectedDay: Day?

    @State var lowerDate: Day?
    @State var upperDate: Day?
    
    @State var rangeDays: ClosedRange<Day>?
    @State var isRangeCalendarMode: Bool = true
    
    @State var isSelectedFirstDateInRange: Bool = false
    @State var isSelectedSecondDateInRange: Bool = false
    @State var isAnimated = true
        
    var dateTitles: [String] = ["Неделя", "Месяц"] // "Все время"

    init(
        coordinator: ReportViewCoordinator
    ){
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
        
        self.viewModel.setup()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if isAnimated {
                    SegmentedControlView(countOfItems: 3, segments: viewModel.isEnableTypeOfReprot,
                                         selectedIndex: $viewModel.selectedTypeOfReport,
                                         currentTab: viewModel.isEnableTypeOfReprot[0])
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    
                    SegmentedControlView(countOfItems: 2, segments: dateTitles,
                                         selectedIndex: $viewModel.dateSelectedIndex,
                                         currentTab: dateTitles[0])
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                if viewModel.selectedTypeOfReport != 2 {
                    HStack {
                        if viewModel.dateSelectedIndex == 0 {
                            HStack {
                                Image("rc-ic-toBeforeWeek")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        toBeforeWeekDidTap()
                                    }
                                
                                Image("rc-ic-toNextWeek")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        toNextWeekDidTap()
                                    }
                            }
                        }
                        
                        if viewModel.dateSelectedIndex == 1 {
                            HStack {
                                Image("rc-ic-toBeforeWeek")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        toBeforeMonthDidTap()
                                    }
                                
                                Image("rc-ic-toNextWeek")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        toNextMonthDidTap()
                                    }
                            }
                        }
                        
                        
                        Spacer()
                        
                        Text(viewModel.dateSelectedIndex == 0 ? "\(coordinator.viewModel.firstDayOfWeek!).\(coordinator.viewModel.currentShortMonthForFrom!) - \(coordinator.viewModel.lastDayOfWeek!).\(coordinator.viewModel.currentShortMonthForTo!), \(coordinator.viewModel.currentYear!)" : "\(coordinator.viewModel.shortDateMonthForTo!), \(coordinator.viewModel.currentYear!)")
                            .foregroundColor(Colors.Primary.blue)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                        
                        Image("rc-ic-information")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                informationDidTap()
                            }
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 22)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                }
                
                if isAnimated {
                    if viewModel.selectedTypeOfReport == 0 || viewModel.selectedTypeOfReport == 1 {
                        if viewModel.dateSelectedIndex == 0 {
                            WeekAnimationChart(
                                weekChartViewModel: $viewModel.chartDataViewModel,
                                showLoader: $viewModel.showLoader
                            )
                                .transition(.move(edge: .top).combined(with: .opacity))
                        } else {
                            MonthChart(viewModel: viewModel,
                                       monthChartViewModel: $viewModel.chartDataViewModel,
                                       showLoader: $viewModel.showLoader)
                        }
                        
                        CircleEmotionChart(
                            emotionStateCounts: $viewModel.emotionCountData.countState,
                            emotionNames: $viewModel.emotionCountData.text,
                            emotionColors: $viewModel.emotionCountData.color,
                            emotionTotal: $viewModel.emotionCountData.total,
                            emotionCircleViewModel: $viewModel.emotionCountData.emotionCircleViewModel,
                            isLoading: $viewModel.showLoader,
                            dataIsEmpty: $viewModel.emotionCountData.dataIsEmpty
                        )
                        
                        if viewModel.isMonthCurrentTab {
                            if viewModel.isStressCurrentTab {
                                ReportTipView(
                                    text: "Твой уровень стресса в этом месяце в большинстве случаев был ",
                                    selectedText: $viewModel.emotionCountData.common,
                                    isShowLoader: $viewModel.showLoader,
                                    tipType: .commonEmotionStateStress
                                )
                                .padding(.top, -16)
                            } else {
                                ReportTipView(
                                    text: "Твоим самым частым настроением этого месяца стало ",
                                    selectedText: $viewModel.emotionCountData.common,
                                    isShowLoader: $viewModel.showLoader,
                                    tipType: .commonEmotionState
                                )
                                .padding(.top, -16)
                            }
                            
                        } else {
                            if viewModel.isStressCurrentTab {
                                ReportTipView(
                                    text: "Твой уровень стресса на этой неделе в большинстве случаев ",
                                    selectedText: $viewModel.emotionCountData.common,
                                    isShowLoader: $viewModel.showLoader,
                                    tipType: .commonEmotionStateStress
                                )
                                .padding(.top, -16)
                            } else {
                                ReportTipView(
                                    text: "Твоим самым частым настроением этой недели стало ",
                                    selectedText: $viewModel.emotionCountData.common,
                                    isShowLoader: $viewModel.showLoader,
                                    tipType: .commonEmotionState
                                )
                                .padding(.top, -16)
                            }
                        }
                       
                        
                        DayilyCharts(viewModel: $viewModel.timeDataViewModel)
                            .padding(.top, 16)
                                                
                        ActivitiesCharts(
                            goodActivitiesViewModel: $viewModel.goodActivitiesDataViewModel,
                            badActivitiesViewModel: $viewModel.badActivitiesDataViewModel,
                            isMonthCurrentTab: $viewModel.isMonthCurrentTab,
                            isStressCurrentTab: $viewModel.isStressCurrentTab,
                            isShowLoader: $viewModel.showLoader
                        )
                    } else {
                        ActivitiesChartsForAllTime()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: viewModel.showLoader, perform: { newValue in
            withAnimation(.linear(duration: 0.5)) {
                if !isAnimated {
                    self.isAnimated = true
                }
            }
        })
    }
    
    private func calendarViewDidTap() {
        showDatePicker.toggle()
    }
    
    private func clearCalendar() {
        lowerDate = nil
        upperDate = nil
        rangeDays = nil
    }
    
    private func checkWeeklySelected(lowerDate: Day?, upperDate: Day?) -> Bool {
        guard let lowerDate = lowerDate,
              let upperDate = upperDate else { return false }
        return lowerDate.day + 6 == upperDate.day
    }
    
    private func toBeforeWeekDidTap() {
        viewModel.chartDataViewModel = []
        viewModel.toBeforeWeekDidTap()
    }
    
    private func toNextWeekDidTap() {
        viewModel.chartDataViewModel = []
        viewModel.toNextWeekDidTap()
    }
    
    private func toBeforeMonthDidTap() {
        viewModel.toBeforeMonthDidTap()
    }
    
    private func toNextMonthDidTap() {
        viewModel.toNextMonthDidTap()
    }
    
    private func informationDidTap() {
        print("informationDidTap")
    }
}

// MARK: - For CalendarData
struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
