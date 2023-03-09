//
//  JournalView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI
import SwiftUIDatePickerDialog
import HorizonCalendar

struct JournalView: View {
            
    var animation: Namespace.ID

    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: JournalViewCoordinator

    @State var selectedIndex: Int = 0
    @State var showMoreInfo: Bool = false
    @State var currentID: Int = 1
    
//    @State private var beginingDate = Date()
//    @State private var endDate = Date()

    @State var choosedDate: Date = Date()
    @State var showDatePicker: Bool = false
    
    @State var selectedDay: Day?
    
    @State var lowerDate: Day?
    @State var upperDate: Day?
    
    @State var rangeDays: ClosedRange<Day>?
    
    @State var isSelectedFirstDateInRange: Bool = false
    @State var isSelectedSecondDateInRange: Bool = false
    
    @State var isRangeCalendarMode: Bool = false // enum

    @State var currentModel: JournalViewModel?
    
    init(
        coordinator: JournalViewCoordinator,
        animation: Namespace.ID,
        showAuthMethodView: Bool = false
    ){
        self.coordinator = coordinator
        self.animation = animation
        self.viewModel = coordinator.viewModel
    }
    
//    let titles: [String] = ["Общий отчет", "Журнал"]
//    let dates: [String] = ["week", "mounth", "year", "all"]
    
    var body: some View {
        
        VStack {
            SearchView(showCalendar: $showDatePicker, choosedDays: $selectedDay, rangeDays: $rangeDays)
                .padding(.top, 24)
            
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        EmotionBoardView(data: coordinator.viewModel.journalViewModels ?? [],
                                         wasTouched: { id in
                            currentID = id
                            currentModel = coordinator.viewModel.journalViewModels?[currentID]
                            
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                                showMoreInfo.toggle()
                                //                            coordinator.isHiddenTabBar(true)
                            }
                        }, animation: animation)
                    }
                    .background(.white)
                }
                
                if showMoreInfo {
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        ForEach(0..<(coordinator.viewModel.journalViewModels?.count ?? 0), id: \.self) { i in
                            if currentID == coordinator.viewModel.journalViewModels?[i].id {
                                
                                DetailJournalView(showMoreInfo: $showMoreInfo, animation: animation, model: $currentModel)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .leading)
                                
                            }
                        }
                    }
                    .background(.white)
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
                
                VStack(spacing: 10) {
                    Text("Выбери дату или укажи диапоз дат")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.top, 16)
                    
                    //                Text("\(lowerDate?.description ?? "") - \(upperDate?.description ?? "")")
                    //                    .font(.system(size: 16, weight: .regular))
                    //                    .foregroundColor(Colors.TextColors.cadetBlue600)
                    //                    .frame(maxWidth: .infinity, alignment: .leading)
                    //                    .padding(.horizontal, 12)
                    //                    .opacity(lowerDate == nil ? 0 : 1)
                    //                    .transition(.opacity)
                }
                
                Toggle(isOn: $isRangeCalendarMode) {
                    Text("Выбор диапазона")
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                
                CalendarViewRepresentable(lowerDate: lowerDate, upperDate: upperDate, selectedDay: selectedDay, onSelect: { day in
                    
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
                
                Divider()
                
                HStack {
                    MTButton(buttonStyle: .outline, title: "Очистить") {
                        clearCalendar()
                    }
                    .frame(width: 100, height: 40)
                    
                    Spacer()
                    
                    MTButton(buttonStyle: .fill, title: "Применить") {
                        guard let lowerDate = lowerDate, let upperDate = upperDate else { return }
                        rangeDays = lowerDate...upperDate
                        
                        //                    clearCalendar()
                        showDatePicker.toggle()
                    }
                    .frame(width: 100, height: 40)
                    .disabled(isRangeCalendarMode ? upperDate == nil || lowerDate == nil : selectedDay == nil) // тут нужна еще разделние на выбранный тип отмечания
                }
                .frame(height: 100)
                .padding(.horizontal, 16)
            }
            .onChange(of: isRangeCalendarMode) { _ in
                if isRangeCalendarMode {
                    self.selectedDay = nil
                } else {
                    //                selectedDay = nil
                    
                    lowerDate = nil
                    upperDate = nil
                    
                    //                isSelectedFirstDateInRange.toggle()
                    //                isSelectedSecondDateInRange.toggle()
                }
                
            }
        }
    }
    
    private func clearCalendar() {
        lowerDate = nil
        upperDate = nil
        
        selectedDay = nil
        
//        isSelectedFirstDateInRange.toggle()
//        isSelectedSecondDateInRange.toggle()
    }
}



//            SegmentedControlView(countOfItems: 2, segments: titles, selectedIndex: $selectedIndex, currentTab: titles[0])
//                .padding(.vertical, 24)
//                .padding(.horizontal, 16)
////                    SegmentedControlView(countOfItems: 4, segments: dates, currentTab: dates[0], styleSegmentControl: .gray)
//            if selectedIndex == 0 {
//
//                VStack(spacing: 12) {
//                    MoodBarCharsView()
//
//                    ActivitiesBarCharsView()
//
//                    FeelingCircleChartsView(completed: 3)
//
//                    Spacer()
//                }
//            } else {
//                VStack(spacing: 12) {
//                   EmotionBoardView()
//
//                    EmotionBoardView(emotionBoardViewModels: [])
//
//                    EmotionBoardView(emotionBoardViewModels: [
//                        EmotionBoardViewModel(data: "12:20", emotionTitle: "Very happy", activities: [ActivitiesViewModel(name: "travel")], color: .cyan, emotionImage: "happy"),
//                        EmotionBoardViewModel(data: "12:20", emotionTitle: "Very happy", activities: [ActivitiesViewModel(name: "travel")], color: .indigo, emotionImage: "happy")
//                    ])
//
//                    Spacer()
//                }
//            }
