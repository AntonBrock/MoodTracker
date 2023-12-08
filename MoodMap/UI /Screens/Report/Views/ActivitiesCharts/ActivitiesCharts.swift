//
//  ActivitiesCharts.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct ActivitiesCharts: View {
    
    @Binding var goodActivitiesViewModel: GoodActivitiesReportDataViewModel
    @Binding var badActivitiesViewModel: BadActivitiesReportDataViewModel
    
    @Binding var isMonthCurrentTab: Bool
    @Binding var isStressCurrentTab: Bool
    
    @Binding var isShowLoader: Bool
    
    var body: some View {
        VStack {
            if !goodActivitiesViewModel.dataIsEmpty {
                createGoodActivitiesView(goodActivitiesViewModel)
            } else {
                createEmptyAcitiviewsView()
            }
            
            if isMonthCurrentTab {
                if isStressCurrentTab {
                    ReportTipView(
                        text: "Самое успокаивающее в этом месяце ",
                        selectedText: $goodActivitiesViewModel.bestActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .goodActivitiesStress
                    )
                    .padding(.top, -16)
                } else {
                    ReportTipView(
                        text: "Активность, которая тебя радовала больше всего в этом месяце ",
                        selectedText: $goodActivitiesViewModel.bestActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .goodActivities
                    )
                    .padding(.top, -16)
                }
            } else {
                if isStressCurrentTab {
                    ReportTipView(
                        text: "Самое успокаивающее на этой неделе ",
                        selectedText: $goodActivitiesViewModel.bestActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .goodActivitiesStress
                    )
                    .padding(.top, -16)
                } else {
                    ReportTipView(
                        text: "Активность, которая тебя радовала больше всего на этой недели ",
                        selectedText: $goodActivitiesViewModel.bestActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .goodActivities
                    )
                    .padding(.top, -16)
                }

            }
            
            if !badActivitiesViewModel.dataIsEmpty {
                createBadActivitiesView(badActivitiesViewModel)
            } else {
                createEmptyAcitiviewsView()
            }
            
            if isMonthCurrentTab {
                if isStressCurrentTab {
                    ReportTipView(
                        text: "Самое тревожное в этом месяце ",
                        selectedText: $badActivitiesViewModel.worstActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .badActivitiesStress
                    )
                    .padding(.top, -16)
                } else {
                    ReportTipView(
                        text: "Активность, которая тебя радовала больше всего в этом месяце ",
                        selectedText: $badActivitiesViewModel.worstActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .badActivities
                    )
                    .padding(.top, -16)
                }
            } else {
                if isStressCurrentTab {
                    ReportTipView(
                        text: "Самое тревожное на этой неделе ",
                        selectedText: $badActivitiesViewModel.worstActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .badActivitiesStress
                    )
                    .padding(.top, -16)
                } else {
                    ReportTipView(
                        text: "Активность, которая расстраивала больше всего на этой недели ",
                        selectedText: $badActivitiesViewModel.worstActivity,
                        isShowLoader: $isShowLoader,
                        tipType: .badActivities
                    )
                    .padding(.top, -16)
                }
            }
            
        }
        .padding(.bottom, 26)
    }
    
    @ViewBuilder
    private func createGoodActivitiesView(_ viewModel: GoodActivitiesReportDataViewModel) -> some View {

        let flexibleLayout = Array(repeating: GridItem(.fixed(80), spacing: -10),
                                   count: viewModel.activities.count >= 3 ? 3 : viewModel.activities.count)

        LazyVGrid(columns: flexibleLayout) {
            if !viewModel.activities.isEmpty {
                ForEach (viewModel.activities, id: \.id) { item in
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Colors.Secondary.shamrock600Green)
                                .overlay {
                                    Text("\(item.count <= 10 ? "\(item.count)" : "10+")")
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
                                    Image(item.image)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                                }
                        }
                    }
                    .padding(.top, 15)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 20)

    }
    
    @ViewBuilder
    private func createBadActivitiesView(_ viewModel: BadActivitiesReportDataViewModel) -> some View {
        
        let flexibleLayout = Array(repeating: GridItem(.fixed(80), spacing: -10),
                                   count: viewModel.activities.count >= 3 ? 3 : viewModel.activities.count)
        LazyVGrid(columns: flexibleLayout) {
            
            if !viewModel.activities.isEmpty {
                ForEach (viewModel.activities, id: \.id) { item in
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Colors.Secondary.malibu600Blue)
                                .overlay {
                                    Text("\(item.count <= 10 ? "\(item.count)": "10+")")
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
                                    Image(item.image)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                                }
                        }
                    }
                    .padding(.top, 15)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func createEmptyAcitiviewsView() -> some View {
        
        HStack(spacing: -10) {
            ForEach(0..<3) { index in
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "ECEDF0"))
                            .overlay {
                                Text("")
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
                                Image("")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "ECEDF0"), lineWidth: 1)
                            }
                    }
                }
                .frame(width: 80, height:80)
            }
        }
    }
}
