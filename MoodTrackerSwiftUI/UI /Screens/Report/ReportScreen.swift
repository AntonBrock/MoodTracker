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
    var dateTitles: [String] = ["Неделя", "Месяц"]
    
    @State var sampleAnalytics: [SiteView] = sample_analytics
    @State var currentPlot = ""
    @State var offset: CGSize = CGSize(width: 100, height: 200)
    @State var showPlot = false
    @State var translation: CGFloat = 0
    
    var body: some View {
        ScrollView {
            
            VStack {
                
                SegmentedControlView(countOfItems: 3, segments: typeTitles, selectedIndex: $typeSelectedIndex, currentTab: typeTitles[0])
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                SegmentedControlView(countOfItems: 2, segments: dateTitles, selectedIndex: $dateSelectedIndex, currentTab: dateTitles[0])
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                
                
//                LineChartView(data: [0, 25, 40, 0, 89], title: "", form: CGSize(width: UIScreen.main.bounds.width - 16, height: 240), rateValue: nil, dropShadow: false, valueSpecifier: "%.1f процентов")
//                    .frame(maxWidth: .infinity, maxHeight: 240, alignment: .top)
                
                // Chart
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

//                HStack {
//                    PieChartView(
//                        values: [10, 20, 60, 0, 10],
//                        names: ["Очень хорошо", "Хорошо", "Нормально", "Плохо", "Очень плохо"],
//                        formatter: {value in String(format: "$%.2f", value)},
//                        colors: [Color(hex: "FFC794"), Color(hex: "86E9C5"), Color(hex: "B283E4"), Color(hex: "B9C8FD"), Color(hex: "F5DADA")],
//                        backgroundColor: .white
//                    )
//                    .frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
////                    .clipped()
//                }
//                .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(.red)
//                        .padding(.leading, 10)
//                        .padding(.trailing, 10)
////                            .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
//                )
////                .clipped()
                
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
}

var sample_analytics: [SiteView] =
    [
        SiteView (hour: Date() .updateHour (value: 8), views: 1500, animate: false),
        SiteView(hour: Date() .updateHour (value: 9), views: 2625,  animate: false),
        SiteView (hour: Date() .updateHour (value: 10), views: 7500,  animate: false),
        SiteView (hour: Date() .updateHour (value: 11), views: 3688,  animate: false),
        SiteView (hour: Date () .updateHour (value: 12), views: 1000,  animate: false)
    ]
