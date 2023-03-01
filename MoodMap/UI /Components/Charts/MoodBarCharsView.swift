//
//  MoodBarCharsView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 03.10.2022.
//

import SwiftUI

struct MoodBarCharsView: View {
    
    @State var pickerSelectedItem = 0
    @State var dataPoints: [[CGFloat]] = [
        [50, 150, 150, 30, 40, 20, 50],
        [90, 100, 50, 100, 10, 10, 30],
        [10, 20, 30, 50, 150, 10, 20]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                Text("Mood")
                    .font(.system(size: 32))
                    .fontWeight(.medium)
                    .foregroundColor(Colors.TextColors.cello900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 24, leading: 20, bottom: 0, trailing: 0))
                
                HStack {
                    VStack {
                        Text("H s i")
                            .foregroundColor(Colors.TextColors.cadetBlue600)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("V s i")
                            .foregroundColor(Colors.TextColors.cadetBlue600)
                            .fontWeight(.medium)
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 45, trailing: 0))

                    
                    HStack(spacing: 30) {
                        BarView(value: dataPoints[pickerSelectedItem][0])
                        BarView(value: dataPoints[pickerSelectedItem][1])
                        BarView(value: dataPoints[pickerSelectedItem][2])
                        BarView(value: dataPoints[pickerSelectedItem][3])
                        BarView(value: dataPoints[pickerSelectedItem][4])
                        BarView(value: dataPoints[pickerSelectedItem][5])
                        BarView(value: dataPoints[pickerSelectedItem][6])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                        .animation(.default)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
        .background(Color.white)
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)

    }
}

// MARK: - BarView
struct BarView: View {
    
    var value: CGFloat = 0
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 13, height: 150)
                    .foregroundColor(Colors.TextColors.athensGray300)
                Capsule().frame(width: 13, height: value)
                    .foregroundColor(Colors.Secondary.peachOrange500Orange)
            }
            Text("D")
                .foregroundColor(Colors.TextColors.cadetBlue600)
                .fontWeight(.medium)
                .padding(.top, 8)
        }
        
    }
}
