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
        
    var dateTitles: [String] = ["Неделя", "Месяц"] // "Все время"

    init(
        coordinator: ReportViewCoordinator
    ){
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
        coordinator.viewModel.getDates()
    }
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                Text("Is Loading ...")
            } else {
                VStack {
                    SegmentedControlView(countOfItems: 3, segments: viewModel.isEnableTypeOfReprot,
                                         selectedIndex: $viewModel.selectedTypeOfReport,
                                         currentTab: viewModel.isEnableTypeOfReprot[0])
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    SegmentedControlView(countOfItems: 2, segments: dateTitles,
                                         selectedIndex: $viewModel.dateSelectedIndex,
                                         currentTab: dateTitles[0])
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    
                    if viewModel.selectedTypeOfReport != 2 {
                        HStack {
                            
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
                            .opacity(viewModel.dateSelectedIndex == 0 ? 1 : 0)
                            
                            
                            Spacer()
                            
                            Text(viewModel.dateSelectedIndex == 0 ? "\(coordinator.viewModel.firstDayOfWeek!).\(coordinator.viewModel.currentShortMonthForFrom!) - \(coordinator.viewModel.lastDayOfWeek!).\(coordinator.viewModel.currentShortMonthForTo!), \(coordinator.viewModel.currentYear!)" : "\(coordinator.viewModel.shortDateMonthForFrom!), \(coordinator.viewModel.currentYear!)")
                                .foregroundColor(Colors.Primary.blue)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .center)

                            Spacer()
                            
                            if viewModel.dateSelectedIndex == 1 {
                                Image("rc-ic-calendar")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        monthDidTap()
                                    }
                            } else {
                                Image("rc-ic-information")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        informationDidTap()
                                    }
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 22)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    }
                    
                    if viewModel.selectedTypeOfReport == 0 || viewModel.selectedTypeOfReport == 1 {
                        if viewModel.dateSelectedIndex == 0 {
                            WeekAnimationChart(weekChartViewModel: viewModel.reportViewModel?.chartData ?? [])
//                                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                                    .onEnded({ value in
//                                        if value.translation.width < 0 {
//                                            coordinator.viewModel.toBeforeWeekDidTap()
//                                        }
//
//                                        if value.translation.width > 0 {
//                                            coordinator.viewModel.toNextWeekDidTap()
//                                        }
//                                    }))
                        } else {
                            MonthChart(viewModel: viewModel,
                                       monthChartViewModel: viewModel.reportViewModel?.chartData ?? [])
                        }
                        
                        CircleEmotionChart(
                            emotionStateCounts: $viewModel.emotionCountData.countState,
                            emotionNames: $viewModel.emotionCountData.text,
                            emotionColors: $viewModel.emotionCountData.color,
                            emotionTotal: $viewModel.emotionCountData.total
                        )
                        
                        ReportTipView(
                            text: "Твоим самым частым настроением стало ",
                            selectedText: viewModel.reportViewModel?.emotionCountData.common ?? "",
                            tipType: .commonEmotionState
                        )
                        .padding(.top, -16)
                        
                        DayilyCharts(viewModel: viewModel.reportViewModel?.timeData)
                        
                        //                        ReportTipView(text: "")
                        
                        ActivitiesCharts(goodActivitiesViewModel: viewModel.reportViewModel?.goodActivitiesReportData,
                                         badActivitiesViewModel: viewModel.reportViewModel?.badActivitiesReportData)
                    } else {
                        ActivitiesChartsForAllTime()
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .popover(isPresented: $showDatePicker) {
            HStack {
                Button {
                    clearCalendar()
                    showDatePicker.toggle()
                } label: {
                    Image("crossIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 12)
                        .padding(.top, 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 37)
            
            VStack(spacing: 10) {
                Text( "Выбери день или укажи несколько")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                    .padding(.trailing, 10)
                    .padding(.top, 24)
                
                //                Text("\(lowerDate?.description ?? "") - \(upperDate?.description ?? "")")
                //                    .font(.system(size: 16, weight: .regular))
                //                    .foregroundColor(Colors.TextColors.cadetBlue600)
                //                    .frame(maxWidth: .infinity, alignment: .leading)
                //                    .padding(.horizontal, 12)
                //                    .opacity(lowerDate == nil ? 0 : 1)
                //                    .transition(.opacity)
            }
            
            Toggle(isOn: $isRangeCalendarMode) {
                Text("Выбор нескольких дней")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
            }
            .frame(width: UIScreen.main.bounds.width - 32, height: 64)
            .tint(Colors.Primary.lavender500Purple)
            
            CalendarViewRepresentable(isWeeklyCalendar: true,
                                      lowerDate: lowerDate,
                                      upperDate: upperDate,
                                      selectedDay: selectedDay,
                                      onSelect: { day in
                if isRangeCalendarMode {
                    if !isSelectedFirstDateInRange {
                        self.lowerDate = day
                        self.isSelectedFirstDateInRange.toggle()
                        
                        if isSelectedSecondDateInRange {
                            self.upperDate = nil
                        }
                    } else {
                        self.upperDate = day
                        self.isSelectedSecondDateInRange.toggle()
                        self.isSelectedFirstDateInRange.toggle()
                    }
                } else {
                    self.selectedDay = day
                }
                
            })
            .frame(width: UIScreen.main.bounds.width - 32)
            .padding(.top, 5)
                            
            HStack {
                MTButton(buttonStyle: .outline, title: "Очистить") {
                    clearCalendar()
                    isChoosindNewDate = false
                }
                .frame(maxWidth: 160, maxHeight: 48)

                Spacer()
                
                MTButton(buttonStyle: .fill, title: "Применить") {
                    if isRangeCalendarMode {
                        guard let lowerDate = lowerDate,
                                let upperDate = upperDate else { return }
                        rangeDays = lowerDate...upperDate
                        
                        //                    clearCalendar()
                        showDatePicker.toggle()
                        isChoosindNewDate.toggle()
                    }
                    
                }
                .frame(maxWidth: 160, maxHeight: 48)
                .disabled(!checkWeeklySelected(lowerDate: lowerDate, upperDate: upperDate))
                // тут нужна еще разделние на выбранный тип отмечания
            }
            .frame(height: 100)
            .padding(.horizontal, 16)
        }
//        .onChange(of: isChoosindNewDate, perform: { _ in
//            guard let lowerDate = lowerDate,
//                    let upperDate = upperDate
//            else {
////                coordinator.viewModel.getJournalViewModel()
//                return
//            }
////            coordinator.viewModel.getJournalViewModel(from: lowerDate.description,
////                                                      to: upperDate.description)
//        })
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
        coordinator.viewModel.toBeforeWeekDidTap()
    }
    
    private func toNextWeekDidTap() {
        coordinator.viewModel.toNextWeekDidTap()
    }
    
    private func monthDidTap() {
        print("monthDidTap")
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
