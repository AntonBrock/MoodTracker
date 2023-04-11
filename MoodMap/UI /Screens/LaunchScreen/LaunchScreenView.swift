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
                ContentView(coordinator: parent)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            self.isSplashScreenShow.toggle()
        }
        
    }
}
