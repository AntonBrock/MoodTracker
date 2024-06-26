//
//  MoodCheckView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 29.12.2022.
//

import SwiftUI
import HorizonCalendar

struct MoodCheckView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var valueModel: SliderValueModele
    @ObservedObject var userStateVideModel: ViewModel
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)
        
    @State var value: Double = 20
    
    let container: DIContainer
    unowned let coordinator: MoodCheckViewCoordinator
    
    init(container: DIContainer,
         coordinator: MoodCheckViewCoordinator,
         valueModel: SliderValueModele
        ){
        self.container = container
        self.coordinator = coordinator
        self.valueModel = valueModel
        
        self.userStateVideModel = coordinator.userStateViewModel
    }
    
    @State var selectedTime: Date = Date()
    
    @State private var date = Date()

    @State var timeViewText: String = "Сегодня"
    @State var showDatePicker: Bool = false
    @State var showChoosingTimePicker: Bool = false
    
    @State var selectedDay: Day?
    @State var choosedTimeDate = Date()
    
    @State var formatedTimeDate: String = ""
    
    @State var isShowLoader: Bool = false

    var body: some View {
        
        VStack {
            HStack {
                Image("crossIcon")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.leading, 18)
                    .onTapGesture {
                        withAnimation {
                            print(Services.authService.jwtToken)
                            dismiss.callAsFunction()
                        }
                    }
                
                Text("Как себя чувствуешь ?")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.leading, -42)
            }
            .frame(width: UIScreen.main.bounds.width, height: 48, alignment: .center)
            
            if isShowLoader {
                LoaderLottieView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ZStack {
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            ScrollViewReader { proxy in
                                VStack {
                                    VStack {
                                        Button(action: {
                                            showDatePicker.toggle()
                                        }, label: {
                                            
                                            Text("\(timeViewText) \(getCurrentTime())")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(Colors.Primary.blue)
                                                .padding(.leading, 16)
                                                .padding(.vertical, 8)
                                            
                                            Image("chevronDownIcon")
                                                .foregroundColor(Colors.TextColors.cello900)
                                                .frame(width: 25, height: 25, alignment: .center)
                                                .padding(.trailing, 16)
                                                .padding(.vertical, 8)
                                        })
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.white)
                                                .shadow(color: Colors.TextColors.mystic400, radius: 4, x: 0, y: 0)
                                        )
                                    }
                                    .padding(.top, 10)
                                    
                                    if !coordinator.userStateViewModel.statesViewModel.isEmpty {
                                        MoodCheckComponent(statesViewModel: coordinator.userStateViewModel.statesViewModel,
                                                           setChoosedState: { choosedState in
                                            self.userStateVideModel.choosedState = choosedState
                                            self.userStateVideModel.choosedEmotion = nil
                                        }, valueModel: valueModel, value: $value)
                                        .padding(.top, 15)
                                    }
                                    
                                    if !coordinator.userStateViewModel.emotionsViewModel.isEmpty {
                                        MoodsWordChooseView(emotionViewModel: coordinator.userStateViewModel.emotionsViewModel,
                                                            valueModel: valueModel,
                                                            setChoosedEmotion: { choosedEmotion in
                                            self.userStateVideModel.choosedEmotion = choosedEmotion
                                        }, leftAction: {
                                            if valueModel.value < 40 {
                                                valueModel.value = valueModel.value + 10
                                            }
                                        }, rightAction: {
                                            if valueModel.value > 0 {
                                                valueModel.value = valueModel.value - 10
                                            }
                                            
                                        })
                                        .padding(.top, -20)
                                        .id(1)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                .background(.white)
                                .onChange(of: valueModel.value) { _ in
                                    withAnimation {
                                        impactLight.impactOccurred()
                                        proxy.scrollTo(1, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .background(.white)
                        .padding(.bottom, 72)
                    }
                    
                    VStack {
                        MTButton(buttonStyle: .fill, title: "Продолжить") {
                            Services.metricsService.sendEventWith(eventName: .stateNextButton)
                            Services.metricsService.sendEventWith(eventType: .stateNextButton)
                            
                            userStateVideModel.choosedTimeDate = choosedTimeDate
                            coordinator.openAcitivitiesScreen(with: userStateVideModel)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 44, alignment: .bottom)
                        .padding(.bottom, 24)
                        .disabled(coordinator.userStateViewModel.choosedState == nil || userStateVideModel.choosedEmotion == nil)
                        .opacity(coordinator.userStateViewModel.choosedState != nil ||  userStateVideModel.choosedEmotion != nil ? 1 : 0.7)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: .infinity, alignment: .bottom)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: .infinity)
            }
        }
        .popover(isPresented: $showDatePicker) {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            clearCalendar()
                            showDatePicker = false
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
                        Text("Выбери дату")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Colors.Primary.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                            .padding(.trailing, 10)
                            .padding(.top, 24)
                    }
                    
                    CalendarViewRepresentable(selectedDay: selectedDay, onSelect: { day in
                        self.selectedDay = day
                    })
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .padding(.top, 5)
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            Text("Выбор точного времени:")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Colors.Primary.blue)
                            
                            Spacer()
                            
                            Text("\(getCurrentTime())")
                                .padding()
                                .background(Color(hex: "F0F2F8"))
                                .cornerRadius(15)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Colors.Primary.blue)
                                .padding(.leading, 16)
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    showDatePicker = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.showChoosingTimePicker = true
                                    }
                                }
                           
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 16)
                        
                        HStack {
                            MTButton(buttonStyle: .outline, title: "Очистить") {
                                clearCalendar()
                                withAnimation {
                                    showDatePicker = false
                                }
                            }
                            .frame(maxWidth: 160, maxHeight: 48)
                            
                            Spacer()
                            
                            MTButton(buttonStyle: .fill, title: "Применить") {
                                let formatter = DateFormatter()
                                formatter.timeStyle = .short
                                formatter.locale = Locale(identifier: "ru_RU")
                                let dateTimeString = formatter.string(from: choosedTimeDate)
                                self.formatedTimeDate = dateTimeString
                                
                                self.timeViewText = "\(selectedDay?.description ?? "Сегодня")"
                                withAnimation {
                                    showDatePicker = false
                                }
                            }
                            .frame(maxWidth: 160, maxHeight: 48)
//                            .disabled(selectedDay == nil || selectedTime == Date())
                        }
                        .frame(height: 100)
                        .padding(.horizontal, 16)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .popover(isPresented: $showChoosingTimePicker, content: {
            VStack {
                HStack {
                    Button {
                        self.showChoosingTimePicker = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.showDatePicker = true
                        }
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
                    Text("Выбор точного времени")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Colors.Primary.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                        .padding(.trailing, 10)
                        .padding(.top, 24)
                }
                
                Spacer()
                
                DatePicker(
                    "",
                    selection: $choosedTimeDate,
                    displayedComponents: .hourAndMinute
                )
                .onChange(of: choosedTimeDate, perform: { newValue in
                    self.selectedTime = newValue
                })
                .frame(height: 216)
                .datePickerStyle(.wheel)
//                .environment(\.timeZone, TimeZone(secondsFromGMT: +3)!) // forRussia - +3
                .labelsHidden()

                Spacer()

                Divider()
                
                VStack {
                    HStack {
                        MTButton(buttonStyle: .outline, title: "Отменить") {
                            self.selectedTime = Date()
                            self.showChoosingTimePicker = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.showDatePicker = true
                            }
                        }
                        .frame(maxWidth: 160, maxHeight: 48)
                        
                        Spacer()
                        
                        MTButton(buttonStyle: .fill, title: "Применить") {
                            self.showChoosingTimePicker = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                #warning("TODO: Сохранить время")
                                self.showDatePicker = true
                            }
                        }
                        .frame(maxWidth: 160, maxHeight: 48)
                    }
                    .frame(height: 100)
                    .padding(.horizontal, 16)
                }
            }
        })
        .onAppear {
            coordinator.userStateViewModel.choosedState = "45be90af-0404-42dd-8bbe-66d67787840f"
            
            if coordinator.userStateViewModel.statesViewModel.isEmpty
                && coordinator.userStateViewModel.activitiesViewModel.isEmpty
                && coordinator.userStateViewModel.emotionsViewModel.isEmpty
                && coordinator.userStateViewModel.statesViewModel.isEmpty
            {
                coordinator.userStateViewModel.fetch(self)
            }
        }
    }
    
    func showLoader() {
        isShowLoader = true
    }
    
    func hideLoader() {
        isShowLoader = false
    }
    
    private func clearCalendar() {
        selectedDay = nil
        formatedTimeDate = ""
        timeViewText = "Cегодня"
    }
    
    private func getCurrentTime() -> String {
        
        if formatedTimeDate == "" {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "ru_RU")
            
            let dateString = formatter.string(from: selectedTime)
            return dateString
        } else {
            return formatedTimeDate
        }
    }
}
