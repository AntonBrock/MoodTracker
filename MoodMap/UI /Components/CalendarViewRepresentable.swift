//
//  CalendarViewRepresentable.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.01.2023.
//

import UIKit
import SwiftUI
import HorizonCalendar

struct CalendarViewRepresentable: UIViewRepresentable {
    
//    @Binding var startDate: Date
//    @Binding var endDate: Date
    
    var lowerDate: Day?
    var upperDate: Day?
    
    var selectedDay: Day?
    var onSelect: (Day?) -> Void
                   
    func makeUIView(context: Context) -> CalendarView {
        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.daySelectionHandler = onSelect
        
        return calendarView
    }
    
    func updateUIView(_ uiView: CalendarView, context: Context) {
        uiView.setContent(self.makeContent())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func makeContent() -> CalendarViewContent {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
       
        let selectedDay = self.selectedDay
        
        let lowerDate = self.lowerDate
        let upperDate = self.upperDate
        
        let startDate = Date() //когда учетка была создана дата
        let threeMonthsFromToday = Calendar.current.date(byAdding: DateComponents(month: 12), to: startDate)!
        
        var dateRangeToHighlight: ClosedRange<Date>
        var overlaidItemLocation: CalendarViewContent.OverlaidItemLocation = .day(containingDate: Date())

        if let lowerDate = lowerDate {
            overlaidItemLocation = .day(containingDate: calendar.date(from: lowerDate.components) ?? Date())
        }
        
        if let lowerDate = lowerDate,
            let upperDate = upperDate,
            let lowerDayDate = calendar.date(from: lowerDate.components),
            let upperDayDate = calendar.date(from: upperDate.components) {
            
            if lowerDate <= upperDate {
                dateRangeToHighlight = lowerDayDate...upperDayDate
            } else {
                dateRangeToHighlight = Date()...Date()
            }
        } else {
            dateRangeToHighlight = Date()...Date()
        }
        
        return CalendarViewContent(
          calendar: calendar,
          visibleDateRange: startDate...threeMonthsFromToday,
          monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
        .overlayItemProvider(for: [overlaidItemLocation]) { overlayLayoutContext in
            TooltipView.calendarItemModel(
                invariantViewProperties: .init(
                    backgroundColor: self.lowerDate == nil || self.upperDate != nil ? .clear : .white,
                    borderColor: self.lowerDate == nil || self.upperDate != nil ? .clear : .white,
                    font: UIFont.systemFont(ofSize: 15),
                    textColor: self.lowerDate == nil || self.upperDate != nil ? .clear : UIColor(Colors.Primary.blue)),
                viewModel: .init(
                    frameOfTooltippedItem: overlayLayoutContext.overlaidItemFrame,
                    text: "2 - дня минимум"))
        }
        .dayRangeItemProvider(for: [dateRangeToHighlight]) { dayRangeLayoutContext in
            DayRangeIndicatorView.calendarItemModel(
                    invariantViewProperties: .init(),
                    viewModel: .init(framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
        .dayItemProvider { day in
            let date = calendar.date(from: day.components)!
            
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: UIFont.systemFont(ofSize: 16),
                textColor: UIColor(Colors.Primary.blue),
                backgroundColor: .clear)
            
            if calendar.isDateInToday(date) {
                invariantViewProperties.textColor = UIColor(Color(hex: "BC93E8"))
                invariantViewProperties.backgroundColor = UIColor.white
            }
            
            if day == lowerDate {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = UIColor(Color(hex: "BC93E8"))
            }
            
            if day == upperDate {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = UIColor(Color(hex: "BC93E8"))
            }
            
            if day == selectedDay {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = UIColor(Color(hex: "BC93E8"))
            }
            
            return CalendarItemModel<DayLabel>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day))
        }
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
    }
    
    class Coordinator: NSObject {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
    }
}
struct DayLabel: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        var font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct ViewModel: Equatable {
        let day: Day
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
    {
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 9
        
        return label
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
        view.text = "\(viewModel.day.day)"
    }
}

extension DayRangeIndicatorView: CalendarItemViewRepresentable {
    
    struct InvariantViewProperties: Hashable {
        let indicatorColor = UIColor(Color(hex: "E2CEF7"))
    }
    
    struct ViewModel: Equatable {
        let framesOfDaysToHighlight: [CGRect]
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView
    {
        DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: DayRangeIndicatorView) {
        view.framesOfDaysToHighlight = viewModel.framesOfDaysToHighlight
    }
}

extension TooltipView: CalendarItemViewRepresentable {
    
    struct InvariantViewProperties: Hashable {
        let backgroundColor: UIColor
        let borderColor: UIColor
        let font: UIFont
        let textColor: UIColor
    }
    
    struct ViewModel: Equatable {
        let frameOfTooltippedItem: CGRect?
        let text: String
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> TooltipView
    {
        TooltipView(
            backgroundColor: invariantViewProperties.backgroundColor,
            borderColor: invariantViewProperties.borderColor,
            font: invariantViewProperties.font,
            textColor: invariantViewProperties.textColor)
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: TooltipView) {
        view.frameOfTooltippedItem = viewModel.frameOfTooltippedItem
        view.text = viewModel.text
    }
    
}
