//
//  FeelingView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 26.12.2022.
//

import SwiftUI

struct FeelingView: View {
    
    @State var value: Double = 20
    
    var body: some View {
        VStack {
//            MoodCheckComponent(setChoosedState: { state in
//                print("хуй")
//            }, valueModel: SliderValueModele(), value: $value)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(.white)
    }
}
