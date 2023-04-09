//
//  MonthChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct MonthChart: View {
    
    @State var viewModel: ReportScreen.ViewModel?
    
    @Binding var monthChartViewModel: [ChartDataViewModel]
    @State var subReportInfo: [ReportCurrentViewModel] = []
    
    @State var showDaylyMonthDetails: Bool = false
    
    #warning("TODO: Вызывается по 3 раза!")
    @State var currentDate: Date = Date() {
        didSet {
            self.subReportInfo = []
            viewModel?.fetchCurrentDate(
                date: currentDate,
                completion: { subReportInfo in
                    self.subReportInfo = subReportInfo
            })
        }
    }
    @State var currentMonth: Int = 0

    var body: some View {
        VStack {
            let days: [String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Colors.Primary.lightGray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 16)
            
            let column = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: column, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    Colors.Primary.lightGray.opacity(isSameDay(date1: Date(),
                                                                               date2: currentDate)
                                                                     ? 0.0
                                                                     : 0.5),
                                    lineWidth: 1)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            guard monthChartViewModel.first(where: { task in
                                currentDate = value.date
                                showDaylyMonthDetails = true
                                return isSameDay(date1: task.date2, date2: currentDate)
                            }) != nil else {
                                currentDate = value.date
                                showDaylyMonthDetails = false
                                return
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 16)
        .onChange(of: currentMonth, perform: { newValue in
            currentDate = getCurrentMonth()
        })
        
        if showDaylyMonthDetails {
            VStack(spacing: 20) {
                Text("\(getFormattedChoosedDate(currentDate))")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, alignment: .center)

                if let task = monthChartViewModel.first(where: { task in
                    return isSameDay(date1: task.date2, date2: currentDate)
                }) {
                    ForEach(subReportInfo, id: \.stateRate) { task in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                HStack(spacing: 16) {
                                    ZStack {
                                        VStack{}
                                            .background(
                                                Circle()
                                                    .fill(getColorStage(task.stateRate))
                                                    .frame(width: 50, height: 50)

                                            )
                                        VStack{}
                                            .background(
                                                ZStack {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 24, height: 24)

                                                    Circle()
                                                        .fill(getColorStress(task.stressRate))
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
                                        Text(getTitleStage(task.stateRate))
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Colors.Primary.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Text(getTitleStress(task.stressRate))
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(getColorStress(task.stressRate))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    HStack {
                                        activitiesStack(task)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Spacer()

                                Text("\(task.time)")
                                .foregroundColor(Colors.Primary.lightGray)
                                .font(.system(size: 11, weight: .regular))
                            }

                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Colors.TextColors.cadetBlue600.opacity(0.5), radius: 5)
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private func getFormattedChoosedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    private func getTitleStage(_ stage: Int) -> String {
        switch stage {
        case 1: return "Очень плохо"
        case 2: return "Плохо"
        case 3: return "Нормально"
        case 4: return "Хорошо"
        case 5: return "Очень хорошо"
        default: return ""
        }
    }
    
    private func getTitleStress(_ stress: Int) -> String {
        switch stress {
        case 1: return "Низкий стресс"
        case 2: return "Средней стресс"
        case 3: return "Высокий стресс"
        default: return ""
        }
    }
    
    private func getColorStage(_ stage: Int) -> Color {
        switch stage {
        case 1: return Color(hex: "F5DADA")
        case 2: return Color(hex: "B9C8FD")
        case 3: return Color(hex: "B283E4")
        case 4: return Color(hex: "86E9C5")
        case 5: return Color(hex: "FFC794")
        default: return .white
        }
    }
    
    private func getColorStress(_ stress: Int) -> Color {
        switch stress {
        case 1: return Color(hex: "F95555")
        case 2: return Color(hex: "33D299")
        case 3: return Color(hex: "B283E4")
        default: return .white
        }
    }
    
    @ViewBuilder
    func activitiesStack(_ task: ReportCurrentViewModel) -> some View {
        ForEach(0..<task.activities.count) { item in
            if item == 0 || item == 1 || item == 2 {
                Image("\(task.activities[item].image)")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 3)
            }
        }
        
        if task.activities.count > 3 {
            Text("+ \(task.activities.count - 3)")
                .font(.system(size: 12, weight: .medium))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: true, vertical: true)
                .foregroundColor(Colors.TextColors.cadetBlue600)
                .padding(.leading, 5)
                .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = monthChartViewModel.first(where: { task in
                    return isSameDay(date1: task.date2, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSameDay(date1: task.date2, date2: currentDate) ? Colors.Primary.blue : Colors.Primary.blue)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    if isSameDay(date1: task.date2, date2: value.date) {
                        HStack(spacing: 1) {
                            ForEach (0..<task.description.count) { item in
                                Circle()
                                    .fill(getColorForDotEmotion(task.description[item].rate))
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                   
                } else {
                    Text("\(value.day)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? Colors.Primary.lavender500Purple : Colors.Primary.blue)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 44, alignment: .top)
    }
    
    func getColorForDotEmotion(_ data: Int) -> Color {
        switch data {
        case 1: return Color(hex: "F5DADA")
        case 2: return Color(hex: "B9C8FD")
        case 3: return Color(hex: "B283E4")
        case 4: return Color(hex: "86E9C5")
        case 5: return Color(hex: "FFC794")
        default: return Color.red
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"

        let date = formatter.string(from: currentDate)

        return date.components(separatedBy: " ")

    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth,
                                               to: viewModel?.currentMonthDidChoose ?? Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        let range = firstWeekday == 1 ? firstWeekday : firstWeekday - 2
        
        #warning("TODO: На днях когда первое число это воскресенье - не правильно отображется первое число")
        for _ in 0..<range {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
      
        return days
    }
}

struct ReportCurrentViewModel {
    let stateRate: Int
    let stressRate: Int
    let time: String
    let activities: [ReportCurrentDateActivitiesViewModel]
    
    struct ReportCurrentDateActivitiesViewModel {
        let id: String
        let text: String
        let language: String
        let createdAt: Date
        let updatedAt: Date?
        let image: String
        let count: Int
    }
}
func getSampleDate(offset: Int) -> Date {
    let calender = Calendar.current
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}
