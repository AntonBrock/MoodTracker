//
//  AuthLogoutView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 20.04.2023.
//

import SwiftUI
import BottomSheet

struct AuthLogoutView: View {
    
    var dismiss: ((String?) -> Void)
    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop

    var body: some View {
        VStack {}
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [.dynamicTop]) {
            VStack(spacing: 0) {
                Text("Выход из аккаунта")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.Primary.blue)
                    .padding(.top, 14)
                
                MTButton(buttonStyle: .outline, title: "Выйти") {
                    print("Logout Action")
                }
                .frame(maxWidth: 270, maxHeight: 48)
                .padding(.top, 24)
                
                Button {
                    bottomSheetPosition = .absolute(0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss(nil)
                    }
                } label: {
                    Text("Удалить аккаунт")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Colors.Secondary.carnation500Red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 39)
                .padding(.bottom, 59)
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
                dismiss(nil)
            }
        }
    }
}
