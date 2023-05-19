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
    
    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop
    
    let notificationCenter = NotificationCenter.default
    var dismiss: ((String?) -> Void)
    var openAboutRegistration: (() -> Void)
    var dismissWithAppleIDToken: ((String?) -> Void)

    var appleSignInButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
    
    var body: some View {
        VStack {}
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [.dynamicTop]) {
            VStack(spacing: 0) {
                Text("Персональный\nпомощник")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.Primary.blue)
                    .padding(.top, 14)
                
                Text("Войдите, чтобы получить полную\n статистику вашего настроения")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "7A7E80"))
                    .padding(.top, 8)
                
                Button(action: handleSignInButton) {
                    HStack {
                        Image("google_signIn_logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Продолжить с Google")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 279, height: 48, alignment: .center)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                        .fill(Color.black)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 10)
               
                SignInWithAppleButton(.continue) { request in
                        notificationCenter.post(name: Notification.Name("DisabledTabBarNavigation"), object: nil)
                        notificationCenter.post(name: Notification.Name("ShowLoaderPersonalCabinet"), object: nil)
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                
                                guard let appleIDToken = credential.identityToken else {
                                    print("Unable to fetch identity token")
                                    
                                    notificationCenter.post(name: Notification.Name("NotDisabledTabBarNavigation"), object: nil)
                                    notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
                                    
                                    dismissWithAppleIDToken(nil)
                                    return
                                }
                                
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    
                                    notificationCenter.post(name: Notification.Name("NotDisabledTabBarNavigation"), object: nil)
                                    notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
                                    dismissWithAppleIDToken(nil)
                                    return
                                }
                                
                                Services.metricsService.sendEventWith(eventName: .singInWithAppleButton)
                                Services.metricsService.sendEventWith(eventType: .singInWithAppleButton)
                                
                                dismissWithAppleIDToken(idTokenString)
                            default: break
                            }
                        case .failure(let error):
                            print(error)
                            
                            notificationCenter.post(name: Notification.Name("NotDisabledTabBarNavigation"), object: nil)
                            notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
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
        notificationCenter.post(name: Notification.Name("DisabledTabBarNavigation"), object: nil)
        notificationCenter.post(name: Notification.Name("ShowLoaderPersonalCabinet"), object: nil)

        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene

        let rootViewController = scene?
            .windows.first(where: { $0.isKeyWindow })?
            .rootViewController
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController!) { signInResult, error in
                guard let result = signInResult else {
                    // Inspect error
                    notificationCenter.post(name: Notification.Name("NotDisabledTabBarNavigation"), object: nil)
                    notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
                    return
                }
                
                guard let googleJWTToken = result.user.idToken?.tokenString else { fatalError() }
                
                Services.metricsService.sendEventWith(eventName: .singInWithGoogleButton)
                Services.metricsService.sendEventWith(eventType: .singInWithGoogleButton)

                dismiss(googleJWTToken)
            }
    }
}
