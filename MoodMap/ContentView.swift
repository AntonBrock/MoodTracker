//
//  ContentView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var coordinator: BaseViewCoordinator
    @StateObject var viewRouter = ViewRouter()
    @State var isHiddenTabBar: Bool = false
        
    var body: some View {
        ZStack {
            TabBarView(viewRouter: viewRouter,
                       coordinator: coordinator)//isHiddenTabBar: $isHiddenTabBar
            if coordinator.showAuthLoginView {
                VStack {}
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                AuthMethodsView(dismiss: { GToken in
                    guard let gToken = GToken else { return } // показать ошибку
                    coordinator.personalCabinetCoordinator.viewModel.singUp(with: gToken)
                        
                    withAnimation {
                        coordinator.showAuthLoginView.toggle()
                    }
                }, openAboutRegistration: {
                    withAnimation {
                        coordinator.isShowingWhyResgistration.toggle()
                    }
                })
                .zIndex(999999)
            }
            
            if coordinator.isShowingWhyResgistration {
                WhyRegistrationInfoView {
                    withAnimation {
                        coordinator.isShowingWhyResgistration.toggle()
                    }
                    withAnimation {
                        coordinator.showAuthLoginView.toggle()
                    }
                } dismiss: {
                    coordinator.isShowingWhyResgistration.toggle()
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

