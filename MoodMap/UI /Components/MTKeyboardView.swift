//
//  MTKeyboardView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 15.01.2023.
//

import SwiftUI

struct MTKeyboardRectView: View {
    var index: Int
    
    @Binding var password: String
    @Binding var firstEnterPassword: String
    @Binding var isWrongPassword: Bool
        
    var body: some View {
        ZStack {
            Text("1")
//            Circle()
//                .fill(CBColor.lightGray)
//                .frame(width: 12, height: 12)
//                .transition(.opacity)
//
//            if password.count > index {
//                Circle()
//                    .stroke(isWrongPassword
//                            ? CBColor.red
//                            : CBColor.orangeRed, lineWidth: 2)
//                    .background(Circle()
//                        .fill(isWrongPassword
//                              ? CBColor.red
//                              : CBColor.orangeRed))
//                    .frame(width: 12, height: 12)
//                    .transition(.opacity)
//            }
        }
    }
}

// MARK: - CBKeyboardView
struct MTKeyboardView: View {
    
    // MARK: Properties
    @Binding var password: String
    @Binding var firstEnterPassword: String
    @Binding var wrongPass: Bool
//    @Binding var authState: AuthScenario
    
    @State var passwordIsDone: ((String) -> Void)
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
            
            ForEach(1...9, id: \.self) { value in
                MTKeyboardButtonView(value: "\(value)",
                                     password: $password,
                                     firstEnterPassword: $firstEnterPassword,
                                     wrongPass: $wrongPass) { password in //                 authState: $authState
                    passwordIsDone(password)
                }
            }
                            
            MTKeyboardButtonView(value: "",
                                 password: $password,
                                 firstEnterPassword: $firstEnterPassword,
                                 wrongPass: $wrongPass) { password in //                 authState: $authState
                passwordIsDone(password)
            }
            
            MTKeyboardButtonView(value: "0",
                                 password: $password,
                                 firstEnterPassword: $firstEnterPassword,
                                 wrongPass: $wrongPass) { password in //                 authState: $authState

                passwordIsDone(password)
            }
            
            if !password.isEmpty {
                MTKeyboardButtonView(value: "keyboardBackspaceIIcon",
                                     password: $password,
                                     firstEnterPassword: $firstEnterPassword,
                                     wrongPass: $wrongPass) { password in //                authState: $authState
                    passwordIsDone(password)
                }
            }
        }
        .onChange(of: wrongPass) { _ in
            if wrongPass {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    password.removeAll()
                }
            }
        }
    }
}

// MARK: - CBKeyboardButtonView
struct MTKeyboardButtonView: View {

    var value: String
    
    @Binding var password: String
    @Binding var firstEnterPassword: String
        
    @Binding var wrongPass: Bool
//    @Binding var authState: AuthScenario
    
    @State var onTapped: Bool = false
    @State var clouser: ((_ password: String) -> Void)
    
    var body: some View {
        
        Button(action: setPassword, label: {
            VStack {
                if value == "keyboardBackspaceIIcon" {
                    Image(value)
                } else {
                    Text(value)
                        .font(.system(size: 40))
                        .foregroundColor(.black)
                        .fontWeight(.regular)
                }
            }
            .padding()
        })
        .buttonStyle(CBKeyboardButtonStyle())
    }
    
    func setPassword() {
        onTapped = true
        
        if password.count == 4 && wrongPass {
            password.removeAll()
            wrongPass.toggle()
            password.removeAll()
        }
        
        if value == "keyboardBackspaceIIcon" {
            if !password.isEmpty {
                password.removeLast()
            }
            
//            if authState == .setPassword || authState == .changePassword {
//                firstEnterPassword.removeLast()
//            }
//
        } else {
            
            if password.count != 4 {
                
                withAnimation {
                    password.append(value)
                }
                
//                if authState == .setPassword || authState == .changePassword {
//                    withAnimation {
//                        firstEnterPassword.append(value)
//                    }
//                }
                
                if firstEnterPassword.count == 4 {
                    
//                    if authState == .setPassword {
//                        authState = .repeatPassword
//                        password.removeAll()
//                    } else if authState == .changePassword {
//                        authState = .changePasswordRepeat
//                        password.removeAll()
//                    }
                }
                
//                if authState == .repeatPassword || authState == .changePasswordRepeat {
//                    if password.count == 4 && password == firstEnterPassword {
//                        clouser(password)
//                    }
//
//                    if password.count == 4 && password != firstEnterPassword {
//                        let generator = UINotificationFeedbackGenerator()
//
//                        wrongPass.toggle()
//                        generator.notificationOccurred(.error)
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                            wrongPass.toggle()
//                        }
//                    }
//
//                } else if authState == .login {
                    
                    if password.count == 4 {
                        clouser(password)
                    }
//                }
            }
        }
    }
}
// MARK: - CBKeyboardButtonStyle
struct CBKeyboardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .font(.system(size: 31, weight: .medium))
        .frame(width: 64, height: 64, alignment: .center)
        .foregroundColor(Colors.Primary.blue)
        .background(configuration.isPressed
                    ? Colors.TextColors.athensGray300.opacity(0.4)
                    : Color.white)
        .cornerRadius(64 / 2)
    }
}
