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
    
    @Binding var showLoader: Bool
    @Binding var showNeedMoreData: Bool

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
//            let height = proxy.size.height
//            let width = (proxy.size.width) / CGFloat(weekChartViewModel.count - 1)

            ZStack {
                if !weekChartViewModel.isEmpty {
                    if showNeedMoreData {
                        VStack {
                            Image("ch-ic-fine")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Text("Недостаточно данных, чтобы мы смогли подсчитать среднюю оценку,\n тебе нужно больше отмечать свое состояние")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(Colors.Primary.blue)
                                .font(.system(size: 14, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        Chart {
                            ForEach (weekChartViewModel.sorted(by: { $0.date < $1.date })) { item in
                                LineMark(
                                    x: .value("day", item.date),
                                    y: .value("emotion", item.dayRate)
                                )
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
                        .chartYScale(domain: 1...(max == 0 ? 5 : max + 1))
                        .padding(.top, 25)
                        .frame (height: 250)
                        .contentShape(Rectangle())
                    }
                } else {
                    if showLoader {
                        VStack {
                            LottieView(name: "loader", loopMode: .loop)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(height: 250, alignment: .center)
                        .cornerRadius(16)
                    } else {
                        VStack {
                            Image("ch-ic-fine")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Text("За этот период состояние было отмечено 0 раз,\n действуй, а после мы покажем твою статистику")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(Colors.TextColors.fiord800)
                                .font(.system(size: 14, weight: .medium))
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: 250, alignment: .center)
                        .background(.white)
                        .cornerRadius(16)
                        
                    }
                }
            }
        }
        .frame(height: 250)
    }
}
