//
//  AuthDeleteAccountView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 20.04.2023.
//

import SwiftUI
import BottomSheet

struct AuthDeleteAccountView: View {
    
    var dismiss: ((Bool) -> Void)
    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop

    var body: some View {
        VStack {}
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [.dynamicTop]) {
            VStack(spacing: 0) {
                Text("Удаление аккаунта")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Colors.Primary.blue)
                    .padding(.top, 14)
                
                Text("Этим действием, ты удалишь аккаунт и\nвсе связанные с ним данные.\nПредупреждаем, данное действие отменить нельзя.\n\nТы потеряешь все данные о своих состояниях, активностях, статистики, а также свой дневник благодарности")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(hex: "7A7E80"))
                    .padding(.leading, 32)
                    .padding(.top, 8)
                
                MTButton(buttonStyle: .fill, title: "Не удалять") {
                    bottomSheetPosition = .absolute(0)
                    withAnimation {
                        dismiss(false)
                    }
                }
                .frame(maxWidth: 270, maxHeight: 48)
                .padding(.top, 24)
                
                MTButton(buttonStyle: .deleteAction, title: "Удалить мой аккаунт") {
                    bottomSheetPosition = .absolute(0)
                    withAnimation {
                        dismiss(true)
                    }
                }
                .frame(maxWidth: 270, maxHeight: 48)
                .padding(.top, 24)
                .padding(.bottom, 56)
            }
        }
        .customBackground(
            Color.white
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: .white, radius: 0, x: 0, y: 0)
        )
        .enableTapToDismiss(true)
        .enableSwipeToDismiss(true)
        .onDismiss {
            bottomSheetPosition = .absolute(0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                dismiss(false)
            }
        }
    }
}
