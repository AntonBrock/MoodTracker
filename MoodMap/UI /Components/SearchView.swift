//
//  SearchView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 29.12.2022.
//

import SwiftUI
import SwiftUIDatePickerDialog
import HorizonCalendar

struct SearchView: View {
    
    @Binding var showCalendar: Bool
    @Binding var choosedDays: Day?
    @Binding var rangeDays: ClosedRange<Day>?
    
    var body: some View {
        
        HStack {
            Text("\(choosedDays != nil ? choosedDays?.description ?? "" : rangeDays != nil ? rangeDays?.description ?? "" : "Все дни")")
                .foregroundColor(Color(hex: "B4B6B8"))
                .font(.system(size: 16))
                .padding(.leading, 16)
            
            Spacer()
            
            Image("searchIcon")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 16)
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 36)
        .background(Color(hex: "F2F4F5"))
        .cornerRadius(7)
        .onTapGesture {
            
            withAnimation {
                showCalendar.toggle()
            }
        }
    }
}
