//
//  SceneDelegate.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI
import UIKit

enum UserStoryType {
    
    case moodCheckView
    case login
}

@UIApplicationMain
final class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
    
    var window: UIWindow?
    var windowScene: UIWindowScene?
        
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            print("url: \(context.url.absoluteURL)")
            print("scheme: \(String(describing: context.url.scheme))")
            print("host: \(String(describing: context.url.host))")
            print("path: \(context.url.path)")
            print("components: \(context.url.pathComponents)")
            
        }
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        if let windowScene = scene as? UIWindowScene {
            self.windowScene = windowScene

            setupNavbarAppearance()
            setupTabBarAppearance()
            
            let appState = AppState()
            let services = Services(mainScreenService: MainScreenService())
            
            let DIContainer = DIContainer(appState: appState, services: services)
            let coordinator = BaseViewCoordinator(container: DIContainer)

            if false { // check enable codePassword
                startStory(type: .login, parent: coordinator, container: DIContainer)
            } else {
                let contentView = ContentView(coordinator: coordinator) //isHiddenTabBar: appState.$isHiddenTabBar
                
                let window = UIWindow(windowScene: windowScene)
                self.window = window
                
                let vc = UIHostingController(rootView: contentView)
                window.rootViewController = vc
                window.makeKeyAndVisible()
            }
        }
    }
    
    func startStory(type: UserStoryType, parent: BaseViewCoordinator, container: DIContainer) {
        guard let windowScene = windowScene else { fatalError() }

        switch type {
        case .moodCheckView:
            print("1")
        case .login:
            let coordinator = LoginViewCoordinator(parent: parent, container: container)
            let view = LoginView(container: container, coordinator: coordinator)
            
            let window = UIWindow(windowScene: windowScene)
            
            self.window = window
            let vc = UIHostingController(rootView: view)
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - Private methods
private extension SceneDelegate {
    func setupNavbarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor(Colors.Primary.blue)
        ]

        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                                          NSAttributedString.Key.foregroundColor: UIColor(Colors.Primary.blue)]

        appearance.shadowColor = .clear
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()

        appearance.setBackIndicatorImage(UIImage(named: "leftBackBlackArror"),
                                         transitionMaskImage: UIImage(named: "leftBackBlackArror"))

        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }

    func setupTabBarAppearance() {
        // Фоновый цвет таббара
        UITabBar.appearance().barTintColor = .white

        // Цвет иконок таббара
        UITabBar.appearance().tintColor = UIColor(red: 0.47, green: 0.16, blue: 0.91, alpha: 1)
        UITabBar.appearance().isTranslucent = true

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()

            // Фоновый цвет таббара (как выше)
            appearance.backgroundColor = .white

            let image = UIImage.gradientImageWithBounds(
                bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 8),
                colors: [
                    UIColor.clear.cgColor,
                    UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 0.04).cgColor
                ]
            )

            appearance.backgroundImage = UIImage()
            appearance.shadowImage = image

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        }
    }
}
