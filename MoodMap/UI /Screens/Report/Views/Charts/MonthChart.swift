//
//  MonthChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct MonthChart: View {
    
    @State var monthDate: [TaskMetaData] = tasks
    @State var showDaylyMonthDetails: Bool = false
    @State var translation: CGFloat = 0
    
    @State var currentDate: Date = Date()
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
                                .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            guard tasks.first(where: { task in
                                currentDate = value.date
                                showDaylyMonthDetails = true
                                return isSameDay(date1: task.taskDate, date2: currentDate)
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
                Text("\(currentDate)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: currentDate)
                }) {
                    ForEach(task.task) { task in
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
                                        Text(task.title)
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Colors.Primary.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("Средний стресс")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(Colors.Primary.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    #warning("TODO: После получения данных сделать ForEach")
                                    HStack {
                                        Image("emoji_cool")
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                            .padding(.leading, -12)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                                
                                Text(task.time
                                    .addingTimeInterval(CGFloat
                                        .random(in: 0...5000)), style: .time)
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
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? Colors.Primary.blue : Colors.Primary.blue)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    if isSameDay(date1: task.taskDate, date2: value.date) {
                        HStack(spacing: 1) {
                            ForEach (task.task) { taskSub in
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                   
                } else {
                    Text("\(value.day)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? Colors.Primary.blue : Colors.Primary.blue)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 44, alignment: .top)
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
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
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
        
        for _ in 0..<firstWeekday - 2 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

struct TaskReport: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [TaskReport]
    var taskDate: Date
}

func getSampleDate(offset: Int) -> Date {
    let calender = Calendar.current
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [TaskMetaData] = [
    TaskMetaData(task: [
        TaskReport(title: "Talk"),
        TaskReport(title: "Iphoen 13"),
        TaskReport(title: "asdasd")
    ], taskDate: getSampleDate(offset: 3)),
    TaskMetaData(task: [
        TaskReport(title: "Talk"),
    ], taskDate: getSampleDate(offset: -2)),
    
    TaskMetaData(task: [
        TaskReport(title: "Talk"),
    ], taskDate: getSampleDate(offset: -5)),
    
    TaskMetaData(task: [
        TaskReport(title: "Talk"),
    ], taskDate: getSampleDate(offset: -2)),
]
