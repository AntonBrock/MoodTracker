//
//  PulseButton.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 21.09.2023.
//

import SwiftUI

// MARK: - Strucutre for Circle
struct CircleData: Hashable {
    let width: CGFloat
    let opacity: Double
}

struct PulseButton: View {
    
    // MARK: - Properties
    @State private var isAnimating: Bool = false
    var color: Color
    var systemImageName: String
    var buttonWidth: CGFloat
    var numberOfOuterCircles: Int
    var animationDuration: Double
    var circleArray = [CircleData]()
    
    var actionButton: (() -> Void)


    init(color: Color = Color.blue, systemImageName: String = "plus.circle.fill",  buttonWidth: CGFloat = 48, numberOfOuterCircles: Int = 2, animationDuration: Double  = 1, action: @escaping (() -> Void)) {
        self.color = color
        self.systemImageName = systemImageName
        self.buttonWidth = buttonWidth
        self.numberOfOuterCircles = numberOfOuterCircles
        self.animationDuration = animationDuration
        self.actionButton = action
        
        var circleWidth = self.buttonWidth
        var opacity = (numberOfOuterCircles > 4) ? 0.40 : 0.20
        
        for _ in 0..<numberOfOuterCircles{
            circleWidth += 10
            self.circleArray.append(CircleData(width: circleWidth, opacity: opacity))
            opacity -= 0.03
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Group {
                ForEach(circleArray, id: \.self) { cirlce in
                    Circle()
                            .fill(self.color)
                        .opacity(self.isAnimating ? cirlce.opacity : 0)
                        .frame(width: cirlce.width, height: cirlce.width, alignment: .center)
                        .scaleEffect(self.isAnimating ? 1 : 0)
                }
                
            }
            .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
               value: self.isAnimating)

            Button(action: {
                actionButton()
            }) {
                Image(systemName: self.systemImageName)
                    .resizable()
                    .scaledToFit()
                    .background(Circle().fill(Color.white))
                    .frame(width: self.buttonWidth, height: self.buttonWidth, alignment: .center)
                    .accentColor(color)
                
            }
            .onAppear(perform: {
                self.isAnimating.toggle()
            })
        }
    }

}
