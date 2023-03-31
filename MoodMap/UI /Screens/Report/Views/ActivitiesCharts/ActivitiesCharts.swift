//
//  ActivitiesCharts.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct ActivitiesCharts: View {
    
    @State var goodActivitiesViewModel: GoodActivitiesReportDataViewModel?
    @State var badActivitiesViewModel: BadActivitiesReportDataViewModel?
    
    var body: some View {
        VStack {
            if let goodActivitiesViewModel = goodActivitiesViewModel {
                createGoodActivitiesView(goodActivitiesViewModel)
            } else {
                createEmptyAcitiviewsView()
            }
            
            ReportTipView(text: "Активность, которая тебя радовала больше всего ",
                          selectedText: goodActivitiesViewModel?.bestActivity ?? "", tipType: .goodActivities)
            
            if let badActivitiesViewModel = badActivitiesViewModel {
                createBadActivitiesView(badActivitiesViewModel)
            } else {
                createEmptyAcitiviewsView()
            }
            
            ReportTipView(text: "Активность, которая расстраивала больше всего ",
                          selectedText: badActivitiesViewModel?.worstActivity ?? "", tipType: .badActivities)
        }
        .padding(.bottom, 26)
    }
    
    @ViewBuilder
    private func createGoodActivitiesView(_ viewModel: GoodActivitiesReportDataViewModel) -> some View {

        let flexibleLayout = Array(repeating: GridItem(.fixed(80), spacing: -10),
                                   count: viewModel.activities.count >= 3 ? 3 : viewModel.activities.count)

        LazyVGrid(columns: flexibleLayout) {
            ForEach(0..<viewModel.activities.count) { index in
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Colors.Secondary.shamrock600Green)
                            .overlay {
                                Text("\(viewModel.activities[index].count <= 10 ? "\(viewModel.activities[index].count)" : "10+")")
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
                                Image(viewModel.activities[index].image)
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
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 20)

    }
    
    @ViewBuilder
    private func createBadActivitiesView(_ viewModel: BadActivitiesReportDataViewModel) -> some View {
        
        let flexibleLayout = Array(repeating: GridItem(.fixed(80), spacing: -10),
                                   count: viewModel.activities.count >= 3 ? 3 : viewModel.activities.count)
        LazyVGrid(columns: flexibleLayout) {
            ForEach(0..<viewModel.activities.count) { index in
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Colors.Secondary.malibu600Blue)
                            .overlay {
                                Text("\(viewModel.activities[index].count <= 10 ? "\(viewModel.activities[index].count)": "10+")")
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
                                Image(viewModel.activities[index].image)
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
