//
//  MMCircleButton.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 02.09.2023.
//

import SwiftUI

struct CircularButtonWithIcon: View {
    var action: () -> Void
    var imageName: String
    var buttonColor: Color
    var iconColor: Color
    var borderColor: Color
    var borderWidth: CGFloat
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
        }
        .background(.clear)
        .overlay {
            Circle()
                .foregroundColor(.clear)
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .frame(width: 40, height: 40)
        }
    }
}
