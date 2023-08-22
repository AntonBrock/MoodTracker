//
//  StressCheckComponent.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 24.02.2023.
//

import SwiftUI

struct StressCheckComponent: View {
    
    var stressViewModel: [StressViewModel] = []
    let impactLight = UIImpactFeedbackGenerator(style: .light)

    struct SliderConfigure {
        static let min: CGFloat = 0
        static let max: CGFloat = 20
    }
    
    struct SliderSize {
        static let width: CGFloat = 300
        static let height: CGFloat = 50
    }
        
    @ObservedObject var valueModel: SliderStressValueModele
    
    @State var choosedImageId: String = "8b02d308-37fa-41de-bdd2-00303b976031"
    
    var choosedStressID: ((String) -> Void)
    
    var body: some View {
        VStack {
            HStack(spacing: 15 * CGFloat(stressViewModel.count)) {
                
                ForEach(stressViewModel, id: \.id) { item in
                    ZStack {
                        VStack{}
                            .frame(width: choosedImageId == item.id ? 60 : 30,
                                   height: choosedImageId == item.id ? 60 : 30)
                        .overlay(
                            Rectangle()
                                .fill(AngularGradient(gradient:
                                    Gradient(colors: getColors(item.id)),
                                  center: .center))
                                .cornerRadius(82)
                                .opacity(0.5)
                        )
                        .blur(radius: 20)
                        
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: choosedImageId == item.id ? 60 : 30,
                                   height: choosedImageId == item.id ? 60 : 30)
                            .transition(.scale)
                    }
                }
            }

            ZStack {
                SwiftUISlider(thumbBorderWidth: 3,
                              thumbBorderColor: .white,
                              thumbColor: choosedImageId == "fd3f28e0-273b-4a18-8aa8-56e85c9943c0" ? UIColor(Colors.Secondary.riptide500Green)
                              : choosedImageId == "8b02d308-37fa-41de-bdd2-00303b976031" ? UIColor(Colors.Primary.perfume400Purple)
                              : UIColor(Color(hex: "F95555")),
                              minTrackColor: UIColor(Colors.Primary.lightGray),
                              maxTrackColor: UIColor(Colors.Primary.lightGray),
                              minValue: SliderConfigure.min,
                              maxValue: SliderConfigure.max,
                              value: $valueModel.value)
                    .zIndex(1)
                    .frame(width: (40 * CGFloat(stressViewModel.count) + 50), height: SliderSize.height, alignment: .leading)
                    .onChange(of: valueModel.value) { newValue in
                        impactLight.impactOccurred()
                        self.changeImage(for: valueModel.value)
                    }
                
                HStack {
                    let count: Int = stressViewModel.count
                    
                    ForEach(0..<count) { index in
                        VStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10, alignment: .leading)
                                .foregroundColor(Colors.Primary.lightGray)
                        }
                                   
                        if index != (count - 1) {
                            Spacer()
                        }
                    }
                }
                .frame(width: (40 * CGFloat(stressViewModel.count) + 50), height: SliderSize.height)
                .padding(EdgeInsets(top: 1.5, leading: 0, bottom: 0, trailing: 0))
            }
            
            VStack(spacing: 8) {
                Text("\(stressViewModel[Int(valueModel.value / 10.0)].text)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Colors.Primary.blue)
                    .padding(.bottom, -5)
                
                Text("У тебя есть беспокоящие мысли?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
            }
            .padding(.top, 32)
        }
        .onChange(of: choosedImageId) { newValue in
            self.choosedStressID(choosedImageId)
        }
    }
    
    private func getColors(_ id: String) -> [Color] {
        if id == "fd3f28e0-273b-4a18-8aa8-56e85c9943c0" {
            return [Color(hex: "C9F0E2").opacity(1),
                    Color(hex: "33D299").opacity(1)]
        } else if id == "8b02d308-37fa-41de-bdd2-00303b976031" {
            return [Color(hex: "CDA8F5").opacity(1),
                    Color(hex: "B283E4").opacity(1),
                    Color(hex: "B9C8FD").opacity(1)]
        } else if id == "42148e04-8ba7-468d-8ce6-4f25987bdbdf" {
            return [Color(hex: "FFC8C8").opacity(1),
             Color(hex: "F95555").opacity(1)]
        } else { return [] }
    }
    
    private func changeImage(for value: CGFloat) {
        withAnimation {
            choosedImageId = stressViewModel[Int(value / 10.0)].id
        }
    }
}
