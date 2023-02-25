//
//  StressCheckView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 24.02.2023.
//

import SwiftUI

class SliderStressValueModele: ObservableObject {
    @Published var value: Double = 10
}

struct StressCheckView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
//    @ObservedObject var valueModel: SliderStressValueModele
    @State var value: Double = 10
    @State var text: String = ""

    var body: some View {
        VStack {
            HStack {
                Image("leftBackBlackArror")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.leading, 18)
                    .onTapGesture {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                Text("Уровень стресса")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.leading, -42)
            }
            .frame(width: UIScreen.main.bounds.width, height: 48, alignment: .center)
            
            StressCheckComponent(value: $value)
                .padding(.top, 50)
                .id(1)
            
            VStack {
                ZStack {
                    TextEditor(text: $text)
                        .frame(maxWidth: .infinity, maxHeight: 220, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .font(Fonts.InterRegular16)
                        .colorMultiply(Colors.TextColors.porcelain200)
                        .cornerRadius(10)
                        .shadow(color: Colors.TextColors.cadetBlue600, radius: 1.5, x: 0.0, y: 0.0)
                    
                    Text("\("Расскажи о том, что чувствуешь - в будущем это поможет определить почему при определенных занятиях ты себя ощущаешь лучше или хуже")")
                        .font(.system(size: text == "" ? 14 : 16))
                        .foregroundColor(text == "" ? Colors.TextColors.cadetBlue600 : Colors.Primary.blue)
                        .frame(maxWidth: .infinity, maxHeight: 220, alignment: .topLeading)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .opacity(text.isEmpty ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
            .cornerRadius(10)
            .shadow(color: Colors.TextColors.mystic400.opacity(0.3), radius: 4.0, x: 0.0, y: 0.0)
            
            MTButton(buttonStyle: .fill, title: "Сохранить", handle: {
                print("Save")
            })
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
    
