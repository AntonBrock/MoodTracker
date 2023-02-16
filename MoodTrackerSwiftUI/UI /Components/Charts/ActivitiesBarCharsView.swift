//
//  ActivitiesBarCharsView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 29.09.2022.
//

import SwiftUI

// MARK: - ActivitiesBarCharsView
struct ActivitiesBarCharsView: View {
    
    var data: [BarGraphData] = [
        BarGraphData(name: "First", value: 20),
        BarGraphData(name: "Second", value: 10),
        BarGraphData(name: "Third", value: 50),
        BarGraphData(name: "Fourth", value: 90),
        BarGraphData(name: "Five", value: 0),
        BarGraphData(name: "Six", value: 5),
        BarGraphData(name: "Seven", value: 76)
    ]
    
    var body: some View {
        let totalValue = calcTotal(data)
        
        ZStack {
            VStack {
                Text("Activities")
                    .font(.system(size: 32))
                    .fontWeight(.medium)
                    .foregroundColor(Colors.TextColors.cello900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 24, leading: 20, bottom: 0, trailing: 0))
                
                ForEach(data, id:\.self) { item in
                    BarGraphItem(item: item, totalValue: totalValue)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.white)
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
        
    }
    
    private func calcTotal(_ data: [BarGraphData]) -> Int {
        var total = 0
        for i in data {
            total += i.value
        }
        
        return total
    }
}

// MARK: - BarGraphItem
struct BarGraphItem: View {
    
    var item: BarGraphData
    var totalValue: Int
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var maxWidth: CGFloat { screenWidth  * 0.8 }
    
    private var insetWidth: CGFloat {
        if totalValue <= 0 { return 0 }
        
        return ( CGFloat(CGFloat(item.value) * maxWidth / CGFloat(totalValue)) )
    }
    
    private var percentage: Int {
        if totalValue <= 0 { return 0 }
        return ((item.value * 100) / totalValue)
    }
    
    private var calcColor: Color {
        switch item.value {
        case 0...100: return Colors.Secondary.malibu600Blue
        default: return .brown
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.caption)
            
            HStack {
                // Here we need icon of activiteis
                ZStack(alignment: .leading) {
                    Capsule()
                        .foregroundColor(Colors.TextColors.athensGray300)
                        .frame(width: self.maxWidth, height: 12)
                    Capsule()
                        .foregroundColor(calcColor)
                        .frame(width: self.insetWidth, height: 12)
                }
            }
        }
    }
}

// MARK: - BarGraphData
struct BarGraphData: Identifiable, Hashable {
    var id: UUID { UUID () }
    var name: String
    var value: Int
}
 
