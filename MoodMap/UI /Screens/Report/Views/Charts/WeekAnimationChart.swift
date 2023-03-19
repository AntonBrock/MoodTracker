//
//  WeekAnimationChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI
import Charts

struct WeekAnimationChart: View {
    
    @State var sampleAnalytics: [SiteView] = sample_analytics
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
                .contentShape(Rectangle())
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
        for (index, _) in sampleAnalytics.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
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

var sample_analytics: [SiteView] =
    [
        SiteView (hour: Date() .updateHour (value: 8), views: 1500, animate: false),
        SiteView(hour: Date() .updateHour (value: 9), views: 2625,  animate: false),
        SiteView (hour: Date() .updateHour (value: 10), views: 7500,  animate: false),
        SiteView (hour: Date() .updateHour (value: 11), views: 3688,  animate: false),
        SiteView (hour: Date () .updateHour (value: 12), views: 1000,  animate: false)
    ]
