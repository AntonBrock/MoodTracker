//
//  SceneDelegate.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI
import UIKit
import UserNotifications
import OneSignal
import Firebase
import FacebookCore
import JWTDecode

enum UserStoryType {
    case moodCheckView
    case mainScreen
    case login
}

@UIApplicationMain
final class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
    
    var window: UIWindow?
    var windowScene: UIWindowScene?
    
    @State var isNeedShowAuthFromLaunch: Bool = false
    
    static var isAlreadyLaunchedOnce = false
    var isLaunched: Bool = false
    var previousAuthorizationStatus: UNAuthorizationStatus = .notDetermined
        
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            _ = RCValues.sharedInstance
        }
                
        print("OSUSERID: \(AppState.shared.userID)")
        
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        #warning("TODO: После прикручивания координации - сделать открытие экранов")
        let notificationOpenedBlock: OSNotificationOpenedBlock = { result in
            // This block gets called when the user reacts to a notification received
            
            let notification: OSNotification = result.notification
            print("Message: ", notification.body ?? "empty body")
            print("badge number: ", notification.badge)
            print("notification sound: ", notification.sound ?? "No sound")
            
            if let additionalData = notification.additionalData {
                print("additionalData: ", additionalData)
                if let actionSelected = notification.actionButtons {
                    print("actionSelected: ", actionSelected)
                }
            }
        }
        
        OneSignal.setNotificationOpenedHandler(notificationOpenedBlock)
                        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationSettingsDidChange(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        if let windowScene = scene as? UIWindowScene {
            
            self.windowScene = windowScene

            clearKeychainIfWillUnistall()
            setupNavbarAppearance()
            setupTabBarAppearance()
            
            let appState = AppState()
            let services = Services()
            
            let DIContainer = DIContainer(appState: appState, services: services)
            let coordinator = BaseViewCoordinator(container: DIContainer)
                        
            if false { // check enable codePassword
                startStory(
                    type: .login,
                    parent: coordinator,
                    container: DIContainer
                )
            } else {
                
                let launchScreen = LaunchScreenView(parent: coordinator, container: DIContainer)
                
                let window = UIWindow(windowScene: windowScene)
                self.window = window
                
                let vc = UIHostingController(rootView: launchScreen)
                window.rootViewController = vc
                window.makeKeyAndVisible()
            }
        }
    }
    
    #warning("TODO: После изменения координации - прикрутить переходы по экранам отсюда")
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Handle the received push notification when tapped
        if let data = userInfo["data"] as? [String: Any] {
            if let type = data["type"] as? String {
                if let pushType = PushNotificationModel.PushNotificationModelType(rawValue: type) {
                    switch pushType {
                    case .diaryNotes: print("diaryNotes")
                    default: return
                    }
                }
            }
        }
    }
    
    @objc private func notificationSettingsDidChange(_ notification: Notification) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if AppState.shared.isLogin ?? false {
                    if settings.authorizationStatus == .authorized {
                        Services.authService.updatePushNotification(updatePushNotificationToggle: true) { result in }
                        AppState.shared.userPushNotification = true
                        
                        OneSignal.initWithLaunchOptions()
                        OneSignal.setAppId("da77481a-ba27-43f6-8771-37227b99d2e3")
                        OneSignal.setExternalUserId(AppState.shared.userID ?? "")
                    } else {
                        Services.authService.updatePushNotification(updatePushNotificationToggle: false) { result in }
                        AppState.shared.userPushNotification = false
                    }
                }
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        UserDefaults.standard.set(Date(), forKey: "lastActiveDate")
    }
    
    func startStory(type: UserStoryType, parent: BaseViewCoordinator, container: DIContainer) {
        guard let windowScene = windowScene else { fatalError() }

        switch type {
        case .moodCheckView:
            print("1")
        case .mainScreen:
            let contentView = ContentView(
                coordinator: parent,
                isNeedShowAuthPopupFromLaunchScreen: $isNeedShowAuthFromLaunch
            ) //isHiddenTabBar: appState.$isHiddenTabBar
            
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let vc = UIHostingController(rootView: contentView)
            window.rootViewController = vc
            window.makeKeyAndVisible()
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
    
    func clearKeychainIfWillUnistall() {
        let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
        if freshInstall {
            KeychainHelper.standard.delete(service: "isAuthorizated", account: "CHKeychain")
            KeychainHelper.standard.delete(service: "JWT", account: "CHKeychain")
            KeychainHelper.standard.delete(service: "refreshToken", account: "CHKeychain")
            UserDefaults.standard.set(true, forKey: "alreadyInstalled")
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    #warning("TODO: Костыль, который нужно будет вынести в AppState - потому что повторяется в Launch скрине")
        if AppState.shared.isLogin ?? false {
            if !checkJWTIsValid() {
                if checkRefreshTokenIsValid() {
                    Services.authService.refreshToken { result in
                        switch result {
                        case .success:
                            Services.authService.getUserInfo() { result in
                                switch result {
                                case let .success(model):
                                    AppState.shared.userName = model.username
                                    AppState.shared.userEmail = model.email
                                    AppState.shared.userPushNotification = model.settings.notifications
                                    AppState.shared.userLanguage = model.settings.language
                                    AppState.shared.userLimits = model.limits[0].currentValue
                                    AppState.shared.maximumValueOfLimits = model.limits[0].maximumValue
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        case .failure(let error):
                            guard let errorLocaloze = error as? MMError else { return }
                            
                            if errorLocaloze == .defined(.tokenUndefined) {
                                AppState.shared.jwtToken = nil
                            }
                        }
                    }
                } else {
                    AppState.shared.userName = nil
                    AppState.shared.userEmail = nil
                    AppState.shared.userPushNotification = false
                    AppState.shared.userLanguage = "russian"
                    AppState.shared.userLimits = 0
                    AppState.shared.maximumValueOfLimits = 5
                    AppState.shared.isLogin = false
                    AppState.shared.refreshToken = nil
                    AppState.shared.jwtToken = nil
                }
            }
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
    
    #warning("TODO: Костыль, который нужно будет вынести в AppState - потому что повторяется в Launch скрине")
    private func checkJWTIsValid() -> Bool {
        guard let token = AppState.shared.jwtToken else { return false }
        
        do {
            let jwt = try decode(jwt: token)
            
            // Check expiration
            if let expiresAt = jwt.expiresAt {
                let currentDate = Date()
                
                if currentDate > expiresAt {
                    print("Token is expired")
                    return false
                } else {
                    print("Token is valid")
                    return true
                }
            } else {
                print("Token does not have an expiration claim")
                return false
            }
            
        } catch {
            print("Failed to decode JWT token: \(error)")
            return false
        }
    }
    
    private func checkRefreshTokenIsValid() -> Bool {
        guard let token = AppState.shared.refreshToken else { return false }
        
        do {
            let refresh = try decode(jwt: token)
            
            // Check expiration
            if let expiresAt = refresh.expiresAt {
                let currentDate = Date()
                
                if currentDate > expiresAt {
                    print("Token is expired")
                    return false
                } else {
                    print("Token is valid")
                    return true
                }
            } else {
                print("Token does not have an expiration claim")
                return false
            }
            
        } catch {
            print("Failed to decode refresh token: \(error)")
            return false
        }
    }
}
