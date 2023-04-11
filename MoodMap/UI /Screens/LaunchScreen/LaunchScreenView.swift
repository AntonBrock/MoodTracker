//
//  LaunchScreenView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.04.2023.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State var isSplashScreenShow: Bool = false
    
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
        VStack {
            if !isSplashScreenShow {
                Image("ic-launch")
                    .resizable()
                    .frame(width: 78, height: 78)
            } else {
                LottieView(name: "SplashScreen", loopMode: .loop)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            AppState.shared.startStory(type: .mainScreen,
                                                       parent: parent,
                                                       container: container)
                        }
                    }
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isSplashScreenShow.toggle()
            }
        }
    }
}
