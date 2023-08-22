//
//  LoginView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 15.01.2023.
//

import SwiftUI

struct LoginView: View {
    
    let container: DIContainer
    private unowned let coordinator: LoginViewCoordinator
    
    @State var password: String = ""
    @State var firstEnterPassword: String = ""
    @State var code: String = ""
    
    @State var isRecoverPassword: Bool = false
    @State var isAllActive: Bool = false
    @State var wrongPassword = false
    
    @State var title: String = "Давай добавим дополнительную\nзащиту твоим данным"
    
//    @State var tipLabel: String = ""
    
//    @State var isShowTooManyLoginAttemptsPopup = false
//    @State private var wrongAttemptsCount = 0

    @State var onDismiss: (() -> Void)?
    
    init(
        container: DIContainer,
        coordinator: LoginViewCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
    }
    
    var body: some View {
        
        VStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Colors.Primary.blue)
                .multilineTextAlignment(.center)
            //            .padding(.top, 21)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 15) {
                ForEach(0..<4, id: \.self) { index in
                    CodeView(code: getCodeAtIndex(index: index),
                             isActive: getCodeAtIndex(index: index + 1) != "",
                             isAllActive: isAllActive)
                }
            }
            .padding()
            
            //        Spacer()
            
            MTKeyboardView(password: $password,
                           firstEnterPassword: $firstEnterPassword,
                           wrongPass: $wrongPassword,
                           passwordIsDone: { password in
                
                #warning("TODO: Пересмотреть")
                if firstEnterPassword != "" {
                    if firstEnterPassword == password {
                        self.password.append(password)
                        print("GOT IT")
                    } else {
                        print("Password not unic")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.password = ""
                            self.code = ""
                            self.isAllActive.toggle()
                            print("Remove second code")
                        }
                    }
                } else {
                    self.firstEnterPassword = password
                    self.isAllActive.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        title = "Повтори пароль,\nчтобы лучше его запомнить"
                        self.code = ""
                        self.password = ""
                        self.isAllActive.toggle()
                        print(password)
                    }
                }
            })
            .frame(maxWidth: 290, maxHeight: 316, alignment: .center)
            .padding(.bottom)
            .padding(.top, 40)
            
            Spacer()
            
            //        if viewModel.isLogin() {
            //            Button("Не помню пароль") {
            //                self.viewModel.isRecoverPassword = true
            //                viewModel.recoverButtonDidTap()
            //            }
            //            .foregroundColor(CBColor.blue)
            //            .font(.system(size: 14, weight: .bold))
            //            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
            //            .padding(.bottom, 10)
            //        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//    .opacity(viewModel.isLogin() && viewModel.onDismiss == nil ? 1 : 0)
//    .disabled(viewModel.isLogin() && viewModel.onDismiss == nil ? false : true))
//    .onChange(of: viewModel.dismissSelf) { dismissSelf in
//        if dismissSelf {
//            if let onDismiss = viewModel.onDismiss {
//                self.presentationMode.wrappedValue.dismiss()
//                onDismiss()
//                viewModel.dismissSelf.toggle()
//            }
//        }
//    }
    
    func getCodeAtIndex(index: Int) -> String {

        if password.count > index {
            let start = password.startIndex
            let current = password.index(start, offsetBy: index)
            
            return String(password[current])
        }
        
        return ""
    }
}

struct CodeView: View {
    var code: String
    var isActive: Bool
    var isAllActive: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Rectangle()
                .background {
                    Text(isActive || isAllActive ? "*" : code)
                        .foregroundColor(isActive || isAllActive ? Colors.Primary.honeyFlower700Purple : Colors.Primary.blue)
                        .fontWeight(.bold)
                        .font(.title2)
                        .frame(maxHeight: 50, alignment: .center)
                    
                }
                .frame(width: 50, height: 50)
                .foregroundColor(Colors.TextColors.athensGray300.opacity(0.4))
                .cornerRadius(16)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isActive || isAllActive ? Colors.Primary.lavender500Purple : Colors.TextColors.mischka500, lineWidth: 1.5)
                        .shadow(color: isActive || isAllActive ? Colors.Primary.lavender500Purple : Colors.TextColors.mischka500, radius: 5)
                }
        }
    }
}
