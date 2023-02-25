//
//  AuthMethodsView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.01.2023.
//

import SwiftUI
import BottomSheet

struct AuthMethodsView: View {
    
    @State var bottomSheetPosition: BottomSheetPosition = .dynamic
    var dismiss: (() -> Void)
    
    var body: some View {
        VStack {}
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [.dynamic]) {
            VStack(spacing: 0) {
                Text("Персональный\nпомощник")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 14)
                
                Text("Войдите, чтобы получить полную\n статистику вашего настроения")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "7A7E80"))
                    .padding(.top, 8)
                
                Button {
                    print("Google")
                } label: {
                    Image("login_google_icon")
                        .resizable()
                        .frame(width: 279, height: 48, alignment: .center)
                }
                .padding(.top, 14)
                
                Button {
                    print("Apple")
                } label: {
                    Image("login_apple_icon")
                        .resizable()
                        .frame(width: 279, height: 48, alignment: .center)
                }
                .padding(.top, 14)
                
                Button {
                    print("show new screen")
                    
                    bottomSheetPosition = .absolute(0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss()
                    }
                } label: {
                    Text("Зачем нужна учетная запись?")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Colors.Primary.royalPurple600Purple.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 29)
                
                AuthHyperString()
                    .frame(maxWidth: 300, maxHeight: 80)
                    .padding(.top, 20)
                    .padding(.bottom, -20)
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
                dismiss()
            }
        }
    }
}
