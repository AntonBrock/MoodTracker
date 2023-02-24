//
//  StressCheckComponent.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 24.02.2023.
//

import SwiftUI

struct StressCheckComponent: View {
    
    var imagesName: [String] = ["character_veryBad", "character_bad", "character_normal"]
    var stateStressTitleText: [String] = ["Низкий стресс", "Средний стресс", "Высокий стресс"]
    
    var firstImage = "character_veryBad"
    var secondImage = "character_bad"
    var thirdImage = "character_normal"
    
    struct SliderConfigure {
        static let min: CGFloat = 0
        static let max: CGFloat = 20
    }
    
    struct SliderSize {
        static let width: CGFloat = 300
        static let height: CGFloat = 50
    }
        
//    @ObservedObject var valueModel: SliderStressValueModele
    
    @State var choosedImageName: String = "character_veryBad"
    @Binding var value: Double
        
    var body: some View {
        VStack {
            HStack(spacing: 15 * CGFloat(stateStressTitleText.count)) {
                Image(firstImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: choosedImageName == firstImage ? 60 : 30,
                           height: choosedImageName == firstImage ? 60 : 30)
                    .transition(.scale)
                
                Image(secondImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: choosedImageName == secondImage ? 60 : 30,
                           height: choosedImageName == secondImage ? 60 : 30)
                    .transition(.scale)
                
                Image(thirdImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: choosedImageName == thirdImage ? 60 : 30,
                           height: choosedImageName == thirdImage ? 60 : 30)
                    .transition(.scale)
            }
            
            ZStack {
                SwiftUISlider(thumbBorderWidth: 3,
                              thumbBorderColor: UIColor(Colors.Primary.perfume400Purple),
                              thumbColor: .white,
                              minTrackColor: UIColor(Colors.Primary.lightGray),
                              maxTrackColor: UIColor(Colors.Primary.lightGray),
                              minValue: SliderConfigure.min,
                              maxValue: SliderConfigure.max,
                              value: $value)
                    .zIndex(1)
                    .frame(width: (40 * CGFloat(stateStressTitleText.count) + 50), height: SliderSize.height, alignment: .leading)
                    .onChange(of: value) { newValue in
                        self.changeImage(for: value.rounded())
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
            
            Text("\(stateStressTitleText[Int(value.rounded() / 10.0)])")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Colors.Primary.blue)
        }
        
    }
    
    private func changeImage(for value: CGFloat) {
        withAnimation {
            choosedImageName = imagesName[Int(value / 10.0)]
        }
    }
}
