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

    @State var wasOpenedFromTabBar: (() -> Void)?

    @State var selectedIndex: Int = 0
    @State var showMoreInfo: Bool = false
    @State var currentID: String = ""
    
//    @State private var beginingDate = Date()
//    @State private var endDate = Date()

    @State var choosedDate: Date = Date()
    @State var showDatePicker: Bool = false
    @State var isChoosindNewDate: Bool = false
    
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
        showAuthMethodView: Bool = false,
        wasOpenedFromTabBar: (() -> Void)? = nil
    ){
        self.coordinator = coordinator
        self.animation = animation
        self.viewModel = coordinator.viewModel
        self.viewModel.setupViewer(self)
        self.wasOpenedFromTabBar = wasOpenedFromTabBar

        if wasOpenedFromTabBar != nil {
            wasOpenedFromTabBar!()
        }
    }

    var body: some View {
        
        VStack {
            SearchView(showCalendar: $showDatePicker,
                       choosedDays: $selectedDay,
                       rangeDays: $rangeDays)
                .padding(.top, 24)
            
            if viewModel.isShowLoader {
                VStack {
                    LoaderLottieView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ZStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            EmotionBoardView(
                                data: coordinator.viewModel.journalViewModels ?? [],
                                wasTouched: { id in
                                    currentID = id
                                    chooseSelectedModel()
                                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                                    #warning("TODO: Нужна переработка экрана об эмоции, так как выглядит сыро и не вкусно")
    //                                    showMoreInfo.toggle()
    //                                    Services.metricsService.sendEventWith(eventName: .openDetailJournalScreen)
    //                                    Services.metricsService.sendEventWith(eventType: .openDetailJournalScreen)

                                    }
                            }, animation: animation) {
                                coordinator.openMoodCheckScreen()
                            } showAuthViewAction: {
                                withAnimation {
                                    coordinator.parent.showAuthLoginView = true
                                }
                            } showLimitsView: {
                                withAnimation {
                                    coordinator.parent.showLimitsView = true
                                }
                            }
                        }
                        .background(.white)
                    }
                }
                .sheet(isPresented: $showMoreInfo, content: {
                    #warning("TODO: Нужна переработка экрана об эмоции, так как выглядит сыро и не вкусно")
                    DetailJournalView(
                        showMoreInfo: $showMoreInfo,
                        model: $currentModel,
                        shareStateAction: { model in
                            coordinator.parent.journalCoordinator.viewModel.sharingJournalViewModel = model

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                coordinator.parent.isShowingSharingScreen = true
                            }
                    })
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .leading)
                })
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
                        Text("Выбери день или укажи несколько")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Colors.Primary.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                            .padding(.trailing, 10)
                            .padding(.top, 24)
                    }
                    
                    Toggle(isOn: $isRangeCalendarMode) {
                        Text("Выбор нескольких дней")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Colors.Primary.blue)
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                    .tint(Colors.Primary.lavender500Purple)
                    
                    CalendarViewRepresentable(lowerDate: lowerDate,
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
                            } else {
                                showDatePicker.toggle()
                                isChoosindNewDate.toggle()
                            }
                            
                        }
                        .frame(maxWidth: 160, maxHeight: 48)
                        .disabled(isRangeCalendarMode ? upperDate == nil || lowerDate == nil : selectedDay == nil)
                        // тут нужна еще разделние на выбранный тип отмечания
                    }
                    .frame(height: 100)
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    if !(AppState.shared.isLogin ?? false) {
                        viewModel.journalViewModels = []
                    }
                }
                .onChange(of: isChoosindNewDate, perform: { _ in
                    if isRangeCalendarMode {
                        guard let lowerDate = lowerDate,
                                let upperDate = upperDate else {
                            
                            if AppState.shared.isLogin ?? false {
                                coordinator.viewModel.getJournalViewModel()
                            } else {
                                withAnimation {
                                    coordinator.parent.showAuthLoginView = true
                                }
                            }
                            return
                        }
                        
                        if AppState.shared.isLogin ?? false {
                            coordinator.viewModel.getJournalViewModel(from: lowerDate.description,
                                                                      to: upperDate.description)
                        } else {
                            withAnimation {
                                coordinator.parent.showAuthLoginView = true
                            }
                        }
                    } else {
                        guard let selectedDay = selectedDay else {
                            if AppState.shared.isLogin ?? false {
                                coordinator.viewModel.getJournalViewModel()
                            } else {
                                withAnimation {
                                    coordinator.parent.showAuthLoginView = true
                                }
                            }
                            return
                        }
                        
                        let toMonth = selectedDay.month
                        let toDay = selectedDay.day + 1
                        let toDayWith0String = "0" + "\(toDay)"
                        
                        let toDayString = String(toDay <= 9 ? toDayWith0String : "\(toDay)")
                        
                        let to = "\(toMonth)-\(toDayString)"
                        coordinator.viewModel.getJournalViewModel(from: selectedDay.description, to: to)
                    }
                })
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
    }
    
    private func chooseSelectedModel() {
        for index in 0..<coordinator.viewModel.journalViewModels!.count {
            for item in coordinator.viewModel.journalViewModels![index] {
                if item.id == currentID {
                    currentModel = item
                }
            }
        }
    }
    
    private func clearCalendar() {
        lowerDate = nil
        upperDate = nil
        selectedDay = nil
        rangeDays = nil
    }
}
