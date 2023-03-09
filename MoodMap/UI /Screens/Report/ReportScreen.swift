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
    
    @State var typeSelectedIndex: Int = 0
    @State var dateSelectedIndex: Int = 0
    
    var typeTitles: [String] = ["Настроение", "Стресс", "События"]
    var dateTitles: [String] = ["Неделя", "Месяц", "Все время"]
    
    @State var sampleAnalytics: [SiteView] = sample_analytics
    @State var monthDate: [TaskMetaData] = tasks
    @State var currentPlot = ""
    @State var offset: CGSize = CGSize(width: 100, height: 200)
    @State var showPlot = false
    @State var showDaylyMonthDetails: Bool = false
    @State var translation: CGFloat = 0
    
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
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
                        // Chart with graph
                        VStack {
                            AnimationChart()
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.white.shadow(.drop(radius: 2)))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding()
                    } else {
                        
                        // Chart with Month
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

                Capsule()
                    .fill(Color.white)
                    .frame(width: 290, height: 40)
                    .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                    .overlay(
                        Text("Твое общее настроение изменилось на +21% с прошлой недели")
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .padding()
                    )
                    .padding(.top, 30)
                
                RoundedRectangle(cornerRadius: 17)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
                    .clipped()
                    .overlay {
                        PieChartView(
                            values: [10, 20, 60, 0, 10],
                            names: ["Очень хорошо", "Хорошо", "Нормально", "Плохо", "Очень плохо"],
                            formatter: {value in String(format: "$%.2f", value)},
                            colors: [Color(hex: "FFC794"), Color(hex: "86E9C5"), Color(hex: "B283E4"), Color(hex: "B9C8FD"), Color(hex: "F5DADA")],
                            backgroundColor: .white
                        )
                        .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
                        .cornerRadius(16)
                    }
                    .shadow(color: Colors.Primary.lightGray.opacity(0.2), radius: 5, x: 0, y: 0)
                
                Capsule()
                    .fill(Color.white)
                    .frame(width: 290, height: 40)
                    .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                    .overlay(
                        Text("Твое общее настроение изменилось на +21% с прошлой недели")
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .padding()
                    )
                    .padding(.top, 30)
                
                
                #warning("TOOD: Компонент")
                Rectangle()
                    .fill(LinearGradient(
                        gradient: .init(colors: [Color(hex: "7392FC"),
                                                 Color(hex: "FFC8C8")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing // .init(x: 0.25, y: 0.5).init(x: 0.75, y: 0.5)
                    ))
                    .frame(width: 163, height: 58)
                    .overlay {
                        VStack {
                            HStack {
                                Text("Утро")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 12)

                            Text("Очень плохо")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)
                        }
                        .padding(.horizontal, 16)
                    }
                    .cornerRadius(16)
                
                Capsule()
                    .fill(Color.white)
                    .frame(width: 290, height: 40)
                    .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
                    .overlay(
                        Text("Твое общее настроение изменилось на +21% с прошлой недели")
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Colors.Primary.blue)
                            .padding()
                    )
                    .padding(.top, 30)
                
                
                #warning("TOOD: Компонент")
                HStack(spacing: 7) {
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Colors.Secondary.shamrock600Green)
                                .overlay {
                                    Text("2")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, -35)
                                .padding(.leading, 40)
                                .zIndex(9999999)

                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Image("artist_palette_icon")
                                        .resizable()
                                        .frame(width: 30, height: 30)

                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                                }
                        }
                    }.frame(width: 80, height:80)
                    
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Colors.Secondary.malibu600Blue)
                                .overlay {
                                    Text("10+")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, -35)
                                .padding(.leading, 40)
                                .zIndex(9999999)

                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Image("artist_palette_icon")
                                        .resizable()
                                        .frame(width: 30, height: 30)

                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                                }
                        }
                    }.frame(width: 80, height: 80)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: currentMonth, perform: { newValue in
            currentDate = getCurrentMonth()
        })
        .onChange(of: dateSelectedIndex) { newValue in
            
            sampleAnalytics = sample_analytics
            if dateSelectedIndex != 0 {
                for (index, _) in sampleAnalytics.enumerated() {
                    sampleAnalytics[index].views = .random(in: 1500...10000)
                }
            }
            
            animateGraph(fromChange: true)
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
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in sampleAnalytics.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
    
    @ViewBuilder
    func AnimationChart() -> some View {
        let max = sampleAnalytics.max { item1, item2 in
            return item2.views > item1.views
        }?.views ?? 0
                
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(sampleAnalytics.count - 1)
            
            let maxPoint = (sampleAnalytics.max()?.views ?? 0)
            let points = sampleAnalytics.enumerated().compactMap({ item -> CGPoint in
                let progress = item.element.views / maxPoint
                let pathHeight = progress
                
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            })
                                                     

            ZStack {
                Chart {
                    ForEach (sampleAnalytics) {item in
                        LineMark(
                            x: .value("Hour", item.hour, unit: .hour),
                            y: .value("Views", item.animate ? item.views : 0)
                        )
//                        .accessibilityLabel("\(item.views)")
                        .foregroundStyle(
                               .linearGradient(
                                    colors: [ Colors.Secondary.yourPinkRed400,
                                              Colors.Secondary.melrose500Blue,
                                              Colors.Secondary.cruise400Green],
                                    startPoint: .bottom,
                                    endPoint: .top
                               )
                           )
                           .alignsMarkStylesWithPlotArea()
                           .interpolationMethod(.catmullRom)
                    }
                }
                // MARK: Customizing Y-Axis Length
                .chartYScale(domain: 0...(max + 5000))
                .frame (height: 250)
                .onAppear {
                    animateGraph()
                }
                .overlay(
                    VStack(spacing: 0) {
                        Text(currentPlot)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color(.red), in: Capsule())
                            .offset(x: translation < 10 ? 30 : 0)
                            .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                        
                        Rectangle()
                            .fill(Color(.red))
                            .frame(width: 1, height: 45)
                            .padding(.top)
                        
                        Circle()
                            .fill(Color(.red))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                            )
                        
                        Rectangle()
                            .fill(Color(.red))
                            .frame(width: 1, height: 55)
                        
                    }
                        .frame(width: 80, height: 170)
                    // 170 / 2 = 85 - 15 => circle ring
                        .offset(y: 70)
                        .offset(offset),
//                        .opacity(showPlot ? 1 : 0),
                        alignment: .bottomLeading
                )
                .contentShape(Rectangle())
                .gesture(DragGesture().onChanged({ value in
                    withAnimation { showPlot = true }
                    
                    let translation = value.location.x
                    let index = min(Int((translation / width).rounded()), sampleAnalytics.count)
                    currentPlot = "\(sampleAnalytics[index].views)"
                    self.translation = translation

                    offset = CGSize(width: points[index].x, height: points[index].y - points[index].y)
                }).onEnded({ value in
                    withAnimation { showPlot = false }
                }))
            }
        }
        .frame(height: 250)
//        .overlay(
//            VStack(alignment: .leading) {
//                let max = sampleAnalytics.max() ?? 0
//                Text("\(max)")
//                    .font(.caption.bold())
//                Spacer()
//
//                Text("$ 0")
//                    .font(.caption.bold())
//            }
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//        )
    }
}


// MARK: - For CalendarData

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

// MARK: - For LineGraph
struct SiteView: Identifiable, Comparable {
    static func < (lhs: SiteView, rhs: SiteView) -> Bool {
        return rhs != lhs
    }
    
    var id = UUID().uuidString
    var hour: Date
    var views: Double
    var animate: Bool = false
}

extension Date {
    func updateHour(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

var sample_analytics: [SiteView] =
    [
        SiteView (hour: Date() .updateHour (value: 8), views: 1500, animate: false),
        SiteView(hour: Date() .updateHour (value: 9), views: 2625,  animate: false),
        SiteView (hour: Date() .updateHour (value: 10), views: 7500,  animate: false),
        SiteView (hour: Date() .updateHour (value: 11), views: 3688,  animate: false),
        SiteView (hour: Date () .updateHour (value: 12), views: 1000,  animate: false)
    ]


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
