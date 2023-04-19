//
//  AuthMethodsView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.01.2023.
//

import SwiftUI
import BottomSheet
import GoogleSignIn
import GoogleSignInSwift

import AuthenticationServices

struct AuthMethodsView: View {
    
    @State var bottomSheetPosition: BottomSheetPosition = .dynamic
    var dismiss: ((String?) -> Void)
    var openAboutRegistration: (() -> Void)
    var dismissWithAppleIDToken: ((String?) -> Void)

    var appleSignInButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
    
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
                
                GoogleSignInButton(style: .wide, action: handleSignInButton)
                    .frame(width: 279, height: 48, alignment: .center)
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    .padding(.bottom, 10)
                
                SignInWithAppleButton(
                    .continue) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                
                                let userId = credential.user

                                let email = credential.email
                                let firstName = credential.fullName?.givenName
                                let lastName = credential.fullName?.familyName
                                
                                dismissWithAppleIDToken(userId)
                            default: break
                            }
                        case .failure(let error):
                            print(error)
                            dismissWithAppleIDToken(nil)
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 279, height: 48)
                    .padding(.top, 14)
                    .cornerRadius(8)
                
                Button {
                    openAboutRegistration()
                    
                    bottomSheetPosition = .absolute(0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss(nil)
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
                dismiss(nil)
            }
        }
    }
    
    func handleSignInButton() {
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene

        let rootViewController = scene?
            .windows.first(where: { $0.isKeyWindow })?
            .rootViewController
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController!) { signInResult, error in
                guard let result = signInResult else {
                    // Inspect error
                    return
                }
                
                guard let googleJWTToken = result.user.idToken?.tokenString else { fatalError() }
                // нужная инфа для пользователя тут нужно распарсить данные и потправляем (email, name,                                                                                                                            locale, notify (true/ false )
                                                        // отдаем сюда /auth/sign_up -> вернется в ответ наш JWT Token и его сохроняем на клиенте
                                                        // и делаем запрос
                                                        
                // потом будет ручка на получения данных для модели (UserInfoModel)
                dismiss(googleJWTToken)
                // If sign in succeeded, display the app's main content View.
            }
    }
}
