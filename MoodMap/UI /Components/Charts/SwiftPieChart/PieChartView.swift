//
//  PieChartView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//

import SwiftUI

public struct PieChartView: View {
    
    @Binding var values: [Double]
    @Binding var total: Int
    @Binding var emotionsValuesByCategory: [Double]
    @Binding var colors: [Color]
    @Binding var names: [String]
        
    @Binding var emotionCircleViewModel: [EmotionCircleViewModel]?
    
    public let formatter: (Double) -> String
    
    public var backgroundColor: Color = .white
    public var widthFraction: CGFloat = 0.35
    public var innerRadiusFraction: CGFloat = 0.70
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for i in emotionCircleViewModel! {
            let degrees: Double = (Double(i.value) ?? 0) * 360 / sum
            tempSlices.append(
                PieSliceData(
                    startAngle: Angle(degrees: endDeg),
                    endAngle: Angle(degrees: endDeg + degrees),
                    text: String(format: "2f", sum),
                    color: i.color)
            )
            endDeg += degrees
        }
        return tempSlices
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack {
                    if !slices.isEmpty && slices.count <= names.count {
                        ForEach(0..<values.count) { i in
                            PieSlice(pieSliceData: slices[i])
                                .scaleEffect(activeIndex == i ? 1.10 : 1)
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
            emotionCircleViewModel: emotionCircleViewModel?.sorted(by: { $0.value > $1.value })
        )
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

struct PieChartRows: View {
    var emotionCircleViewModel: [EmotionCircleViewModel]?
    
    var body: some View {
        VStack {
            ForEach(emotionCircleViewModel ?? [], id: \.name) { i in
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(i.color)
                        .frame(width: 10, height: 10)
                    Text(i.name)
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 14, weight: .regular))
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(i.value)
                            .foregroundColor(Colors.Primary.lightGray)
                            .font(.system(size: 14, weight: .light))

                    }
                }
                .frame(maxWidth: 160, alignment: .trailing)
                .padding(.top, -10)
            }
        }
        .frame(maxHeight: .infinity,  alignment: .center)
        .padding(.top, 10)
    }
}


