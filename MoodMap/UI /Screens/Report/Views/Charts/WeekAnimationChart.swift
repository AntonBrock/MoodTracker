//
//  WeekAnimationChart.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI
import Charts

struct WeekAnimationChart: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var weekChartViewModel: [ChartDataViewModel]
    @Binding var prevWeekChartsViewModel: [ChartDataViewModel]
    
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
                .fill(colorScheme == .dark ? Colors.Primary.moodDarkBackground.shadow(.drop(radius: 2)) : Color.white.shadow(.drop(radius: 2)))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    @ViewBuilder
    func AnimationChart() -> some View {
        let max = weekChartViewModel.max(by: { $0.dayRate < $1.dayRate })?.dayRate ?? 0
        let maxForPrevWeek = prevWeekChartsViewModel.max(by: { $0.dayRate < $1.dayRate})?.dayRate ?? 0
        
        GeometryReader { proxy in
            ZStack {
                if !weekChartViewModel.isEmpty {
                    if showNeedMoreData {
                        VStack {
                            Image("ch-ic-fine")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Text("Недостаточно данных, чтобы мы смогли подсчитать среднюю оценку,\n тебе нужно больше отмечать свое состояние")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(colorScheme == .dark ? Colors.TextColors.cadetBlue600 : Colors.Primary.blue)
                                .font(.system(size: 14, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding(.top, 25)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        
                    } else {
                        
                        // Charts for prevweek
                        ZStack {
                            Chart {
                                ForEach (prevWeekChartsViewModel.sorted(by: { $0.date < $1.date })) { item in
                                    LineMark(
                                        x: .value("day", item.date),
                                        y: .value("emotion", item.dayRate)
                                    )
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [Colors.Secondary.malibu600Blue],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    .foregroundStyle(by: .value("day", "Предыдущая неделя"))
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                                    .symbol() {
                                        Rectangle()
                                            .fill(Colors.Secondary.malibu600Blue)
                                            .frame(width: 8, height: 8)
                                    }
                                    .symbolSize(30)
                                }
                                .opacity(0.4)
                            }
                            .chartYScale(domain: 1...(maxForPrevWeek == 0 ? 5 : maxForPrevWeek + 1))
                            .frame(maxHeight: 200)
                            .contentShape(Rectangle())
                            .chartYAxis(.hidden)
                            .chartLegend(.hidden)
                            .chartXAxis(.hidden)
                            .opacity(prevWeekChartsViewModel.count <= 2 ? 0 : 0.5)

                            // Chart for current week
                            Chart {
                                ForEach (weekChartViewModel.sorted(by: { $0.date < $1.date })) { item in
                                    LineMark(
                                        x: .value("day", item.date),
                                        y: .value("emotion", item.dayRate)
                                    )
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [Colors.Secondary.yourPinkRed400,
                                                     Colors.Secondary.melrose500Blue,
                                                     Colors.Secondary.cruise400Green
                                                    ],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    .foregroundStyle(by: .value("day", "Текущая неделя"))
                                    .interpolationMethod(.catmullRom)
                                    .symbol() {
                                        Circle()
                                            .fill(Colors.Primary.lavender500Purple.opacity(0.7))
                                            .frame(width: 10)
                                    }
                                    .symbolSize(30)
                                    .accessibilityLabel(item.date)
                                    .accessibilityValue("emotion \(item.dayRate)")
                                    .offset(y: -10)
                                }
                            }
                            .chartYScale(domain: 1...(max == 0 ? 5 : max + 1))
                            .frame(height: 300)
                            .contentShape(Rectangle())
                            .chartForegroundStyleScale([
                                "Текущая неделя": Colors.Primary.lavender500Purple,
                                "Предыдущая неделя": Colors.Secondary.melrose500Blue
                            ])
                            .chartLegend(position: .top, alignment: .top)
                        }
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
                            
                            Text(AppState.shared.isLogin ?? false ? "За этот период состояние было отмечено 0 раз,\n отметь свое состояние, после мы покажем твою статистику" : "Авторизуйся и начни отмечать свое состояние, чтобы мы смогли показать статистику")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(colorScheme == .dark ? Colors.TextColors.cadetBlue600 : Colors.TextColors.fiord800)
                                .font(.system(size: 14, weight: .medium))
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: 250, alignment: .center)
                        .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
                        .cornerRadius(16)
                        
                    }
                }
            }
        }
        .frame(height: 300)
    }
}
