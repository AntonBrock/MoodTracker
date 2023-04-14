//
//  LaunchScreenView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.04.2023.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State var isSplashScreenShow: Bool = false
    @State var animatedIsFinished: Bool = false
    
    @State var isLoadingMainInfo: Bool = false
    
    let parent: BaseViewCoordinator
    let container: DIContainer
    
    @State var isNeedShowPushNotificationScreen: Bool = false
    @State var isShowPushNotificationScreen: Bool = false
    
    @State var isShowATTScreen: Bool = false
    
    init(
        parent: BaseViewCoordinator,
        container: DIContainer
    ) {
        self.parent = parent
        self.container = container
    }
    
    var body: some View {
        
        ZStack {
            if isLoadingMainInfo {
                
                if needShowATT() && !isShowATTScreen {
                    ATTView {
                        AppState.shared.isShowATT = true
                        withAnimation {
                            self.isShowATTScreen = true
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    if !isShowPushNotificationScreen && needShowPushNotification() {
                        PushNotificationView(closeAction: {
                            withAnimation {
                                self.isShowPushNotificationScreen = true
                            }
                        })
                            .transition(.move(edge: .bottom))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        ContentView(coordinator: parent)
                    }
                }

            }
            
            ZStack {
                Color("LaunchScreenBG")
                    .ignoresSafeArea()
                
                LottieView(name: "SplashScreen", loopMode: .loop)
                    .onAppear {
                        // тут делаем запрос на данные для Главного экрана потом и вырубаем либо при показе АТТ, Пушах, Главной
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.spring()) {
                                animatedIsFinished = true
                                isLoadingMainInfo = true
                            }
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .opacity(animatedIsFinished ? 0 : 1)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .onAppear {
            if let showATT = AppState.shared.isShowATT, showATT {
                isShowATTScreen = true
            }
            
            isSplashScreenShow.toggle()
        }
    }
    
    private func needShowATT() -> Bool {
        withAnimation {
            if let showATT = AppState.shared.isShowATT, showATT {
                return false
            } else {
                return true
            }
        }
    }
    
    private func needShowPushNotification() -> Bool {
        withAnimation {
            if let rememberNotificationDate = AppState.shared.rememberPushNotificationDate,
               Date().timeIntervalSince(rememberNotificationDate) > Constants.timeoutRequestNotification {
                AppState.shared.rememberPushNotificationDate = Date()
                return true
            } else if AppState.shared.rememberPushNotificationDate == nil {
                AppState.shared.rememberPushNotificationDate = Date()
                return true
            } else { return false }
        }
    }
}
