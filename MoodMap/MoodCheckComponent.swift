//
//  MoodCheckComponent.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 15.09.2022.
//

import SwiftUI

struct MoodCheckComponent: View {
        
    @Environment(\.colorScheme) var colorScheme

    var statesViewModel: [StatesViewModel] = []
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
    @State var choosedImageId: String = ""
    @Binding var value: Double
    @State var opacity: Double = 0.1

    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
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
                                  center: .center)
                                )
                                .cornerRadius(82)
                                .opacity(opacity + 0.5)
                                .transition(.opacity)
                        )
                        .blur(radius: 20)
                    
                    Image("\(choosedImageName)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 135, height: 135)
                }
                
                ZStack {
                    SwiftUISlider(
                        thumbBorderWidth: 3,
                        thumbBorderColor: UIColor(Colors.Primary.perfume400Purple),
                        thumbColor: .white,
                        minTrackColor: UIColor(Colors.Primary.lightGray),
                        maxTrackColor: UIColor(Colors.Primary.lightGray),
                        minValue: SliderConfigure.min,
                        maxValue: SliderConfigure.max,
                        value: $valueModel.value
                    )
                        .zIndex(1)
                        .frame(width: (40 * CGFloat(statesViewModel.count) + 50), height: SliderSize.height, alignment: .leading)
                        .onChange(of: valueModel.value) { newValue in
                            self.changeImage(for: valueModel.value.rounded())
                        }
                    
                    HStack {
                        let count: Int = statesViewModel.count
                        
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
                    .frame(width: (40 * CGFloat(statesViewModel.count) + 50), height: SliderSize.height)
                    .padding(EdgeInsets(top: 1.5, leading: 0, bottom: 0, trailing: 0))
                }
                
                Text("\(statesViewModel[Int(valueModel.value.rounded() / 10.0)].text)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : Colors.Primary.blue)
            }
            .background(colorScheme == .dark ? Color("Background") : .white)
            .onChange(of: choosedImageName) { newValue in
                self.setChoosedState(choosedImageId)
                withAnimation {
                    self.opacity = self.changeOpaticy(for: valueModel.value.rounded())

                }
            }
        }
    }
    
    private func changeImage(for value: CGFloat) {
        choosedImageName = statesViewModel[Int(value / 10.0)].image
        choosedImageId = statesViewModel[Int(value / 10.0)].id
    }
    
    private func changeOpaticy(for value: CGFloat) -> Double {
        return Double(value / 100.0)
    }
}
