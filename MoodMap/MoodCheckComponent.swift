//
//  MoodCheckComponent.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 15.09.2022.
//

import SwiftUI

struct MoodCheckComponent: View {
    
    var imagesName: [String] = ["ch-ic-veryBad", "ch-ic-sad", "ch-ic-fine", "ch-ic-good", "ch-ic-veryGood"]
    var stateTitleTexts: [String] = ["Очень плохо", "Плохо", "Нормально", "Хорошо", "Лучше всех"]
    
    var setChoosedState: ((String) -> Void)
    
    struct SliderConfigure {
        static let min: CGFloat = 0
        static let max: CGFloat = 40
    }
    
    struct SliderSize {
        static let width: CGFloat = 300
        static let height: CGFloat = 50
    }
        
    @ObservedObject var valueModel: SliderValueModele
    
    @State var choosedImageName: String = "ch-ic-fine"
    @Binding var value: Double

    var body: some View {
        VStack {
            ZStack {
                VStack {}
                    .frame(width: 170, height: 170)
                    .overlay(
                        Rectangle()
                            .fill(AngularGradient(gradient:
                                Gradient(colors:
                                    [Color(hex: "B9C8FD").opacity(0.1),
                                     Color(hex: "B283E4").opacity(0.5),
                                     Color(hex: "E3A8F5").opacity(0.8)]),
                              center: .center))
                            .cornerRadius(82)
                            .opacity(0.5)
                    )
                    .blur(radius: 20)
                
                Image("\(choosedImageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 135, height: 135)
            }
            
            ZStack {
                SwiftUISlider(thumbBorderWidth: 3,
                              thumbBorderColor: UIColor(Colors.Primary.perfume400Purple),
                              thumbColor: .white,
                              minTrackColor: UIColor(Colors.Primary.lightGray),
                              maxTrackColor: UIColor(Colors.Primary.lightGray),
                              minValue: SliderConfigure.min,
                              maxValue: SliderConfigure.max,
                              value: $valueModel.value)
                    .zIndex(1)
                    .frame(width: (40 * CGFloat(stateTitleTexts.count) + 50), height: SliderSize.height, alignment: .leading)
                    .onChange(of: valueModel.value) { newValue in
                        self.changeImage(for: valueModel.value.rounded())
                    }
                
                HStack {
                    let count: Int = stateTitleTexts.count 
                    
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
                .frame(width: (40 * CGFloat(stateTitleTexts.count) + 50), height: SliderSize.height)
                .padding(EdgeInsets(top: 1.5, leading: 0, bottom: 0, trailing: 0))
            }
            
            Text("\(stateTitleTexts[Int(valueModel.value.rounded() / 10.0)])")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Colors.Primary.blue)
        }
        .onChange(of: choosedImageName) { newValue in
            self.setChoosedState(newValue)
        }
        
    }
    
    private func changeImage(for value: CGFloat) {
        choosedImageName = imagesName[Int(value / 10.0)]
    }
}
