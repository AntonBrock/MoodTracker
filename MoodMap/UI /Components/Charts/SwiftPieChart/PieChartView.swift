//
//  PieChartView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//

import SwiftUI

@available(OSX 10.15, *)
public struct PieChartView: View {
    @State var values: [Double]
    @State var total: Int
    @State var emotionsValuesByCategory: [Double]
    
    public let names: [String]
    public let formatter: (Double) -> String
    
    public var colors: [Color]
    public var backgroundColor: Color
    
    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(
                PieSliceData(
                    startAngle: Angle(degrees: endDeg),
                    endAngle: Angle(degrees: endDeg + degrees),
                    text: String(format: "2f", sum),
                    color: self.colors[i])
            )
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(
        total: Int,
        emotionsValuesByCategory: [Double],
        values: [Double],
        names: [String],
        formatter: @escaping (Double) -> String, colors: [Color] = [Color.blue, Color.green, Color.orange],
        backgroundColor: Color = .white,
        widthFraction: CGFloat = 0.35,
        innerRadiusFraction: CGFloat = 0.70
    ) {
        self.total = total
        self.emotionsValuesByCategory = emotionsValuesByCategory
        self.values = values
        self.names = names
        self.formatter = formatter
        
        self.colors = colors
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack {
                    ForEach(0..<self.values.count){ i in
                        PieSlice(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.10 : 1)
                            .animation(Animation.spring())
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                            }
                    )
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction,
                               height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "\(total)" : "\(Int(values[self.activeIndex]))")
                            .font(.title)
                            .foregroundColor(Color.gray)
                    }
                    
                }
                .padding(.leading, 16)
                .foregroundColor(.white)
                
                Spacer()
                
                setChartRows()
            }
            .frame(maxWidth: .infinity, maxHeight: 135, alignment: .center)
            .background(backgroundColor)
        }
    }
    
    @ViewBuilder
    func setChartRows() -> some View {
        PieChartRows(
            count: values.count,
            colors: colors,
            names: names,
            percents: emotionsValuesByCategory.map { String(Int($0)) }
        )
            .frame(maxWidth: .infinity, alignment: .top)
    }
}

@available(OSX 10.15, *)
struct PieChartRows: View {
    var count: Int
    var colors: [Color]
    var names: [String]
    var percents: [String]
    
    var body: some View {
        VStack{
            ForEach(0..<count){ i in
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(self.colors[i])
                        .frame(width: 10, height: 10)
                    Text(self.names[i])
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 14, weight: .regular))
                        .padding(.leading, 10)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.percents[i])
                            .foregroundColor(Colors.Primary.lightGray)
                            .font(.system(size: 14, weight: .light))

                    }
                }
                .frame(maxWidth: 160, alignment: .trailing)
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}


