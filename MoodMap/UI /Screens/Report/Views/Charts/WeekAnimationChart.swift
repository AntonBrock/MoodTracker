//
//  WeekAnimationChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI
import Charts

struct WeekAnimationChart: View {
    
    @Binding var weekChartViewModel: [ChartDataViewModel]
    @State var translation: CGFloat = 0

    var body: some View {
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
    }
    
    @ViewBuilder
    func AnimationChart() -> some View {
        let max = weekChartViewModel.max { item1, item2 in
            return item2.dayRate > item1.dayRate
        }?.dayRate ?? 0
        
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(weekChartViewModel.count - 1)

            ZStack {
                if !weekChartViewModel.isEmpty {
                    Chart {
                        ForEach (weekChartViewModel) { item in
                            LineMark(
                                x: .value("day", item.date),
    //                            y: .value("emotion", item.animate ? item.dayRate : 0)
                                y: .value("emotion", item.dayRate)
                            )
    //                        .accessibilityLabel("\(item.emotion)")
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
                    .chartYScale(domain: 1...(max == 0 ? 5 : 5))
                    .padding(.top, 25)
                    .frame (height: 250)
                    .onAppear {
                        animateGraph()
                    }
                    .contentShape(Rectangle())
                } else {
                    VStack{
                        Text("Видим, что пора начать следить за своим психологическим здоровьем\nпосле мы покажем статистику")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Colors.TextColors.fiord800)
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 250, alignment: .center)
                    .background(.white)
                    .cornerRadius(16)
                }
//                .overlay(
//                    VStack(spacing: 0) {
//                        Text(currentPlot)
//                            .font(.caption.bold())
//                            .foregroundColor(.white)
//                            .padding(.vertical, 6)
//                            .padding(.horizontal, 10)
//                            .background(Color(.red), in: Capsule())
//                            .offset(x: translation < 10 ? 30 : 0)
//                            .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
//
//                        Rectangle()
//                            .fill(Color(.red))
//                            .frame(width: 1, height: 45)
//                            .padding(.top)
//
//                        Circle()
//                            .fill(Color(.red))
//                            .frame(width: 22, height: 22)
//                            .overlay(
//                                Circle()
//                                    .fill(.white)
//                                    .frame(width: 10, height: 10)
//                            )
//
//                        Rectangle()
//                            .fill(Color(.red))
//                            .frame(width: 1, height: 55)
//
//                    }
//                        .frame(width: 80, height: 170)
//                    // 170 / 2 = 85 - 15 => circle ring
//                        .offset(y: 70)
//                        .offset(offset),
////                        .opacity(showPlot ? 1 : 0),
//                        alignment: .bottomLeading
//                )
//                .gesture(DragGesture().onChanged({ value in
//                    withAnimation { showPlot = true }
//
//                    let translation = value.location.x
//                    let index = min(Int((translation / width).rounded()), sampleAnalytics.count)
//                    currentPlot = "\(sampleAnalytics[index].views)"
//                    self.translation = translation
//
//                    offset = CGSize(width: points[index].x, height: points[index].y - points[index].y)
//                }).onEnded({ value in
//                    withAnimation { showPlot = false }
//                }))
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
    
    private func animateGraph(fromChange: Bool = false) {
        for (index, _) in weekChartViewModel.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
//                    weekChartViewModel[index].animate = true
                }
            }
        }
    }
}


//// MARK: - For LineGraph
//struct SiteView: Identifiable, Comparable {
//    static func < (lhs: SiteView, rhs: SiteView) -> Bool {
//        return rhs != lhs
//    }
//
//    var id = UUID().uuidString
//    var emotion: Int
//    var day: String
//    var animate: Bool = false
//}

//var sample_analytics: [SiteView] =
//    [
//        SiteView (emotion: 2, day: "10\nфер"),
//        SiteView(emotion: 4, day: "11\nфер"),
//        SiteView (emotion: 2, day: "12\nфер"),
//        SiteView (emotion: 1, day: "13\nфер"),
//        SiteView (emotion: 5, day: "14\nфер"),
//        SiteView (emotion: 1, day: "15\nфер"),
//        SiteView (emotion: 4, day: "16\nфер")
//    ]
