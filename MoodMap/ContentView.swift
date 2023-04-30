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
    
    let notificationCenter = NotificationCenter.default

    @State var isHiddenTabBar: Bool = false
    @State var openJournaTab: Bool = false

    //isHiddenTabBar: $isHiddenTabBar
    var body: some View {
        ZStack {
            TabBarView(viewRouter: viewRouter,
                       coordinator: coordinator)
            
            if coordinator.showDeleteAccountView {
                VStack {}
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                AuthDeleteAccountView(dismiss: { action in
                    if !action {
                        withAnimation {
                            coordinator.showDeleteAccountView.toggle()
                        }
                    } else {
                    }
                }, agreeToDeleteAccountAction: {
                    notificationCenter.post(name: Notification.Name("ShowLoaderPersonalCabinet"), object: nil)
                    Services.authService.deleteAccount(completion: { result in
                        switch result {
                        case .success:
                            AppState.shared.isLogin = false
                            AppState.shared.jwtToken = nil
                            AppState.shared.refreshToken = nil
                                                            
                            AppState.shared.notificationCenter.post(name: Notification.Name.MainScreenNotification, object: nil)
                            AppState.shared.notificationCenter.post(name: Notification.Name.JournalScreenNotification, object: nil)
                            
                            notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
                            
                            withAnimation {
                                coordinator.showDeleteAccountView.toggle()
                            }
                        case let .failure(error):
                            print(error)
                            withAnimation {
                                coordinator.showDeleteAccountView.toggle()
                            }
                        }
                    })
                })
                .zIndex(999999)
            }
            
            if coordinator.showLogoutView {
                VStack {}
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                AuthLogoutView(dismiss: {
                    withAnimation {
                        coordinator.showLogoutView.toggle()
                    }
                }, logoutAction: {
                    
                    notificationCenter.post(name: Notification.Name("ShowLoaderPersonalCabinet"), object: nil)
                
                    withAnimation {
                        Services.authService.logout { result in
                            switch result {
                            case .success:
                                AppState.shared.isLogin = false
                                AppState.shared.jwtToken = nil
                                AppState.shared.refreshToken = nil
                                
                                notificationCenter.post(name: Notification.Name("HideLoaderPersonalCabinet"), object: nil)
                                
                                AppState.shared.notificationCenter.post(name: Notification.Name.MainScreenNotification, object: nil)
                                AppState.shared.notificationCenter.post(name: Notification.Name.JournalScreenNotification, object: nil)
                                
                                coordinator.showLogoutView.toggle()
                            case let .failure(error):
                                print(error)
                            }
                        }
                    }
                }, deleteAction: {
                    withAnimation {
                        coordinator.showLogoutView.toggle()
                        coordinator.showDeleteAccountView.toggle()
                    }
                })
                .zIndex(999999)
            }
            
            if coordinator.showAuthLoginView {
                VStack {}
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.black.opacity(0.7))
                    .transition(.opacity)
                
                AuthMethodsView(dismiss: { GToken in
                    guard let gToken = GToken else {
                        withAnimation {
                            coordinator.showAuthLoginView.toggle()
                        }
                        
                        return
                    }
                    coordinator.personalCabinetCoordinator.viewModel.singUp(with: gToken)
                    
                    notificationCenter.post(name: Notification.Name("MainScreenNotification"), object: nil)
                    notificationCenter.post(name: Notification.Name("JournalNotification"), object: nil)
                                        
                    withAnimation {
                        coordinator.showAuthLoginView.toggle()
                    }
                }, openAboutRegistration: {
                    withAnimation {
                        coordinator.isShowingWhyResgistration.toggle()
                    }
                }, dismissWithAppleIDToken: { appleIDToken in
                    guard let appleToken = appleIDToken else {
                        withAnimation {
                            coordinator.showAuthLoginView.toggle()
                        }
                        
                        return
                    }
                    
                    coordinator.personalCabinetCoordinator.viewModel.singUp(appleIDToken: appleToken)
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
        .onChange(of: coordinator.isNeedShowTab) { newValue in
            changeViewRouter(page: newValue)
        }
    }
    
    private func changeViewRouter(page: Page) {
        switch page {
        case .jurnal: viewRouter.currentPage = .jurnal
        case .home: viewRouter.currentPage = .home
        case .profile: viewRouter.currentPage = .profile
        case .report: viewRouter.currentPage = .report
        }
    }
}

