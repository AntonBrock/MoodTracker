//
//  ActivitiesTextViewBlock.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.12.2022.
//

import SwiftUI

struct ActivitiesTextViewBlock: View {
    
    enum TextViewType {
        case activities
        case diary
    }

    @State var text: String = ""
    @State var subPlaceholder: String = ""
    @State private var attachmentsView: AttachmentView!
    @State var type: TextViewType = .diary
    
    var saveDiaryText: ((_ text: String) -> Void)?

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    TextEditor(text: $text)
                        .frame(maxWidth: .infinity, maxHeight: type == .diary ? 220 : 85, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .font(Fonts.InterRegular16)
                        .colorMultiply(Colors.TextColors.porcelain200)
                        .cornerRadius(10)
                        .shadow(color: Colors.TextColors.cadetBlue600, radius: 1.5, x: 0.0, y: 0.0)

                    Text("\(type == .diary ? "\(subPlaceholder)" : "Расскажи о том, что чувствуешь - в будущем это поможет определить почему при определенных занятиях ты себя ощущаешь лучше или хуже")")
                        .font(.system(size: text == "" ? 14 : 16))
                        .foregroundColor(text == "" ? Colors.TextColors.cadetBlue600 : Colors.Primary.blue)
                        .frame(maxWidth: .infinity, maxHeight: type == .diary ? 220 : 85, alignment: .topLeading)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .opacity(text.isEmpty ? 1 : 0)
                }
                
                if type == .diary {
                    MTButton(buttonStyle: .fill, title: "Сделать запись в дневник ") {
                        saveDiaryText!(text)
                        text = ""
                    }
                    .frame(width: 256, height: 48)
                    .padding(.top, 10)
                }
                
                if type == .activities {
                    Text("Вы можете добавить до 6 фотографий, но это необазательно")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Colors.Primary.blue)
                        .padding(.leading, 5)
                    
                    AttachmentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                }
               
            }
            .frame(maxWidth: .infinity, maxHeight: type == .diary ? 324 : .infinity, alignment: .center)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .background(.white)
            .cornerRadius(10)
//            .shadow(color: Colors.TextColors.mystic400, radius: 4.0, x: 0.0, y: 0.0)

//            if type == .diary {
//                MTButton(buttonStyle: .outline, title: "Мои записи") {
//                    print("Open next Screen")
//                }
//                .frame(width: 205, height: 48)
//                .padding(.top, 16)
//            }
            
        }
//        .padding(.bottom, 48)
    }
}
