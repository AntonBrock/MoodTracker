//
//  MMErrorView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 20.05.2023.
//

import SwiftUI

struct MMErrorView: View {
    
    @Binding var title: String
    
    @State var dismissAction: (() -> Void)
    
    var body: some View {
        VStack {
            
            Spacer()
            Image("ch-ic-sad")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.top, 48)
            
            Text("Все пошло не по планам")
                .frame(maxWidth: .infinity,  alignment: .center)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 20)
            
            Text("Название ошибки: \(title)\n\nПопробуйте позже или сообщите нам об ошибке через Личный Кабинет")
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 10)
            
            Spacer()

            MTButton(buttonStyle: .fill, title: "Хорошо") {
                dismissAction()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
            
        }
    }
}
