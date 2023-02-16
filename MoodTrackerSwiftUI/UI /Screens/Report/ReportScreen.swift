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

    
    var body: some View {
        ScrollView {
            
            VStack {
                
                SegmentedControlView(countOfItems: 3, segments: typeTitles, selectedIndex: $typeSelectedIndex, currentTab: typeTitles[0])
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                SegmentedControlView(countOfItems: 2, segments: dateTitles, selectedIndex: $dateSelectedIndex, currentTab: dateTitles[0])
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                
                LineChartView(data: [0, 25, 40, 0, 89], title: "", form: CGSize(width: UIScreen.main.bounds.width - 16, height: 240), rateValue: nil, dropShadow: false, valueSpecifier: "%.1f процентов")
                    .frame(maxWidth: .infinity, maxHeight: 240, alignment: .top)

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
    }
    
}
