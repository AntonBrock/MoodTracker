//
//  ShimmerView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 03.10.2023.
//

import SwiftUI

struct ShimmerView: View {
    @State private var moveGradient = true
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        
        Rectangle ()
            .overlay {
                LinearGradient (colors: [.clear, .white, .clear],
                                startPoint: .leading,
                                endPoint: .trailing)
                .offset(x: moveGradient ? -screenWidth/2 : screenWidth/2)
            }
            .animation (.linear(duration: 2).repeatForever (autoreverses: false), value: moveGradient)
            .mask {
                Text ("Slide to power off")
                    .foregroundColor (.black)
                    .font (.largeTitle)
            }
            .onAppear {
                self.moveGradient.toggle()
            }
            .background(.gray)
    }
}
