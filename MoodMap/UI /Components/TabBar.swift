//
//  TabBar.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.09.2022.
//

import SwiftUI
import BottomSheet

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .home
}

enum Page: String {
    case home
    case jurnal
    case report
    case profile
}

struct TabBarView: View {
        
    @Environment(\.dismiss) var dismiss
    
    @Namespace var animation

    @StateObject var viewRouter: ViewRouter
    @ObservedObject var coordinator: BaseViewCoordinator
    
    @State var showPopUp = true
    @State var bottomSheetPosition: BottomSheetPosition = .dynamic
    @State var value: Double = 20
    @State var isNeedToShowActivities: Bool = false
    @State var disabledTabBar: Bool = false

    let isDisabledTabBarNavigation = NotificationCenter.default.publisher(for: NSNotification.Name("DisabledTabBarNavigation"))
    let isNotDisabledTabBarNavigation = NotificationCenter.default.publisher(for: NSNotification.Name("NotDisabledTabBarNavigation"))
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let isiPhoneXOrNewer = geometry.size.height >= 812
                
                VStack {
                    switch viewRouter.currentPage {
                    case .home:
                        MainCoordinatorView(coordinator: coordinator.mainScreenCoordinator, animation: animation)
                    case .jurnal:
                        JournalCoordinatorView(coordinator: coordinator.journalCoordinator)
                    case .report:
                        ReportCoordinatorView(coordinator: coordinator.reportCoordinator)
                    case .profile:
                        PersonalCabinetCoordinatorView(coordinator: coordinator.personalCabinetCoordinator)
                    }
                }
                .background(.clear)
                .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    ZStack {
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "tb-ic-home-none-fill", tabName: "home", filledIconName: "tb-ic-home-fill")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .jurnal, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "tb-ic-jurnall-none-fill", tabName: "jurnal", filledIconName: "tb-ic-jurnall-fill")
                            
                            ZStack {
                                Circle()
                                    .foregroundColor(Colors.Primary.lavender500Purple)
                                    .frame(width: geometry.size.width / 7, height: geometry.size.width / 7)
                                
                                Image("tb-ic-plus")
                                    .resizable()
                                    .frame(width: 25 , height: 25)
                            }
                            .offset(y: -geometry.size.height / 8 / 4)
                            .onTapGesture {
                                
                                if AppState.shared.isLogin ?? false {
                                    withAnimation {
                                        if AppState.shared.userLimits == AppState.shared.maximumValueOfLimits {
                                            coordinator.showLimitsView = true
                                        } else {
                                            coordinator.isShowingMoodCheckScreen.toggle()
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        coordinator.showAuthLoginView = true
                                    }
                                }
                            }
                            .scaleEffect(showPopUp ? CGFloat(0.9) : 1.0)
                            .animation(Animation.spring(response: 0.35, dampingFraction: 0.35, blendDuration: 1), value: showPopUp)
                            .shadow(color: Colors.Primary.lavender500Purple.opacity(0.5), radius: 5, x: 0, y: 9)
                            
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .report, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "tb-ic-report-none-fill", tabName: "report", filledIconName: "tb-ic-report-fill")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "tb-ic-pc-none-fill", tabName: "profile", filledIconName: "tb-ic-pc-fill")
                        }
                        .frame(width: geometry.size.width, height: isiPhoneXOrNewer ? geometry.size.height / 10.0 : geometry.size.height / 12.0)
                        .padding(.top, isiPhoneXOrNewer ? -20 : -5)
                        .disabled(disabledTabBar)
                    }
                    .frame(width: geometry.size.width, height: coordinator.hideCustomTabBar ? 0 : isiPhoneXOrNewer ? geometry.size.height / 10 : geometry.size.height / 12.0)
                    .background(Color.white.clipShape(CustomShape()))
                    .shadow(color: Colors.TextColors.mischka500.opacity(0.7), radius: 7, x: 0, y: -5)
                    .opacity(coordinator.hideCustomTabBar ? 0 : 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.bottom)
            }
            .sheet(isPresented: $coordinator.showLimitsView) {
                UserLimitsView {
                    coordinator.showLimitsView = false
                }
                    .transition(.move(edge: .bottom))
            }
            .sheet(isPresented: $coordinator.showErrorScreen) {
                MMErrorView(title: $coordinator.errorTitle, dismissAction: {
                    coordinator.isShowingMoodCheckScreen = false
                    coordinator.showErrorScreen = false
                })
                    .transition(.move(edge: .bottom))
            }
            .sheet(isPresented: $coordinator.isShowingSharingScreen) {
                SharingView(viewModel: coordinator.journalCoordinator.viewModel.sharingJournalViewModel) {
                    coordinator.isShowingSharingScreen = false
                }
            }
            .sheet(isPresented: $coordinator.isShowingPushNotificationScreen) {
                PushNotificationView {
                    withAnimation {
                        coordinator.isShowingPushNotificationScreen = false
                    }
                }
                    .interactiveDismissDisabled(true)
            }
            .sheet(isPresented: $coordinator.isShowingMoodCheckScreen) {
                print("dissmiss moodCheckScreen")
                coordinator.moodCheckCoordinator = nil
                coordinator.initMoodCheckCoordinator()
            } content: {
                coordinator.openFeelingScreen()
                    .interactiveDismissDisabled(true)
            }
            .onChange(of: viewRouter.currentPage) { newValue in
                coordinator.isNeedShowTab = newValue
            }
        }
        .onAppear {
            PersonalCabinetCoordinatorView(coordinator: coordinator.personalCabinetCoordinator)
        }
        .onReceive(AppState.shared.notificationCenter.publisher(for: NSNotification.Name.MainScreenNotification), perform: { output in
            coordinator.mainScreenCoordinator.viewModel.fetchMainData()
        })
        .onReceive(AppState.shared.notificationCenter.publisher(for: NSNotification.Name.JournalScreenNotification), perform: { output in
            coordinator.journalCoordinator.viewModel.getJournalViewModel()
        })
        .onReceive(isDisabledTabBarNavigation) { (output) in
            disabledTabBar = true
        }
        .onReceive(isNotDisabledTabBarNavigation) { (output) in
            disabledTabBar = false
        }
    }
}

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .frame(width: widthAndHeight, height: widthAndHeight)
                
                Image(systemName: "record.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }

            ZStack {
                Circle()
                    .frame(width: widthAndHeight, height: widthAndHeight)
                
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
                
            }
        }
        .transition(.scale)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    let iconName, tabName: String
    let filledIconName: String

    var body: some View {
        VStack {
            Image("\(viewRouter.currentPage.rawValue == tabName ? filledIconName : iconName)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.bottom, 10)
        }
            .padding(.horizontal, -4)
            .onTapGesture {
                viewRouter.currentPage = assignedPage
            }
            .scaleEffect(viewRouter.currentPage == assignedPage ? CGFloat(0.85) : 1.0)
            .animation(Animation.spring(response: 0.25, dampingFraction: 0.25, blendDuration: 1),
                       value: viewRouter.currentPage == assignedPage)
    }
}

struct CustomShape: Shape {

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))

            let center = rect.width / 2

            path.move(to: CGPoint(x: center - 50, y: 0))

            let to1 = CGPoint(x: center, y: 40)
            let control1 = CGPoint(x: center - 35 , y: 0)
            let control2 = CGPoint(x: center - 35, y: 40)

            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 35 , y: 40)
            let control4 = CGPoint(x: center + 35, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
