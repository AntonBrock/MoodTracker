//
//  StressCheckComponent.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 24.02.2023.
//

import SwiftUI

struct StressCheckComponent: View {
    
    var imagesName: [String] = ["st-ic-low", "st-ic-medium", "st-ic-hight"]
    var stateStressTitleText: [String] = ["Низкий стресс", "Средний стресс", "Высокий стресс"]
    
    var firstImage = "st-ic-low"
    var secondImage = "st-ic-medium"
    var thirdImage = "st-ic-hight"
    
    struct SliderConfigure {
        static let min: CGFloat = 0
        static let max: CGFloat = 20
    }
    
    struct SliderSize {
        static let width: CGFloat = 300
        static let height: CGFloat = 50
    }
        
    @ObservedObject var valueModel: SliderStressValueModele
    @State var choosedImageName: String = "st-ic-medium"
        
    var body: some View {
        VStack {
            HStack(spacing: 15 * CGFloat(stateStressTitleText.count)) {
                
                ZStack {
                    VStack{}
                    .frame(width: choosedImageName == firstImage ? 60 : 30,
                           height: choosedImageName == firstImage ? 60 : 30)
                    .overlay(
                        Rectangle()
                            .fill(AngularGradient(gradient:
                                Gradient(colors:
                                    [Color(hex: "C9F0E2").opacity(1),
                                     Color(hex: "33D299").opacity(1)]),
                              center: .center))
                            .cornerRadius(82)
                            .opacity(0.5)
                    )
                    .blur(radius: 20)
                    
                    Image(firstImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: choosedImageName == firstImage ? 60 : 30,
                               height: choosedImageName == firstImage ? 60 : 30)
                        .transition(.scale)
                }
               
                ZStack {
                    VStack{}
                    .frame(width: choosedImageName == secondImage ? 60 : 30,
                           height: choosedImageName == secondImage ? 60 : 30)
                    .overlay(
                        Rectangle()
                            .fill(AngularGradient(gradient:
                                Gradient(colors:
                                    [Color(hex: "CDA8F5").opacity(1),
                                     Color(hex: "B283E4").opacity(1),
                                     Color(hex: "B9C8FD").opacity(1)]),
                              center: .center))
                            .cornerRadius(82)
                            .opacity(0.5)
                    )
                    .blur(radius: 20)
                    
                    Image(secondImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: choosedImageName == secondImage ? 60 : 30,
                               height: choosedImageName == secondImage ? 60 : 30)
                        .transition(.scale)
                }
                
                ZStack {
                    VStack{}
                    .frame(width: choosedImageName == thirdImage ? 60 : 30,
                           height: choosedImageName == thirdImage ? 60 : 30)
                    .overlay(
                        Rectangle()
                            .fill(AngularGradient(gradient:
                                Gradient(colors:
                                    [Color(hex: "FFC8C8").opacity(1),
                                     Color(hex: "F95555").opacity(1)]),
                              center: .center))
                            .cornerRadius(82)
                            .opacity(0.5)
                    )
                    .blur(radius: 20)
                    
                    Image(thirdImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: choosedImageName == thirdImage ? 60 : 30,
                               height: choosedImageName == thirdImage ? 60 : 30)
                        .transition(.scale)
                }
            }

            ZStack {
                SwiftUISlider(thumbBorderWidth: 3,
                              thumbBorderColor: .white,
                              thumbColor: choosedImageName == firstImage ? UIColor(Colors.Secondary.riptide500Green)
                              : choosedImageName == secondImage ? UIColor(Colors.Primary.perfume400Purple)
                              : UIColor(Color(hex: "F95555")),
                              minTrackColor: UIColor(Colors.Primary.lightGray),
                              maxTrackColor: UIColor(Colors.Primary.lightGray),
                              minValue: SliderConfigure.min,
                              maxValue: SliderConfigure.max,
                              value: $valueModel.value)
                    .zIndex(1)
                    .frame(width: (40 * CGFloat(stateStressTitleText.count) + 50), height: SliderSize.height, alignment: .leading)
                    .onChange(of: valueModel.value) { newValue in
                        self.changeImage(for: valueModel.value)
                    }
                
                HStack {
                    let count: Int = stateStressTitleText.count
                    
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
                .frame(width: (40 * CGFloat(stateStressTitleText.count) + 50), height: SliderSize.height)
                .padding(EdgeInsets(top: 1.5, leading: 0, bottom: 0, trailing: 0))
            }
            
            VStack(spacing: 8) {
                Text("\(stateStressTitleText[Int(valueModel.value / 10.0)])")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Colors.Primary.blue)
                    .padding(.bottom, -5)
                
                Text("У тебя есть беспокоящие мысли?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
            }
            .padding(.top, 32)
        }
    }
    
    private func changeImage(for value: CGFloat) {
        withAnimation {
            choosedImageName = imagesName[Int(value / 10.0)]
        }
    }
}
