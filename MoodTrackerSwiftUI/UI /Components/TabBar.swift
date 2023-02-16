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
        
    @StateObject var viewRouter: ViewRouter
    @ObservedObject var coordinator: BaseViewCoordinator
    
    @State var showPopUp = true
    @Environment(\.dismiss) var dismiss
    
    @State var bottomSheetPosition: BottomSheetPosition = .dynamic
    @State var isHiddenTabBar: Bool = false
    @Namespace var animation
    
    @State var isShowingMoodView: Bool = false
    @State var value: Double = 20
    @State var isNeedToShowActivities: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
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
                    
                    ZStack {
//                        if showPopUp {
//                            PlusMenu(widthAndHeight: geometry.size.width / 7)
//                                .offset(y: -geometry.size.height / 6)
//                        }
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "homeIconNoneFill", tabName: "home", filledIconName: "homeIconFill")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .jurnal, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "jurnalIconNoneFill", tabName: "jurnal", filledIconName: "jurnalIconFill")
                            
                            ZStack {
                                Circle()
                                    .foregroundColor(Colors.Primary.lavender500Purple)
                                    .frame(width: geometry.size.width / 7, height: geometry.size.width / 7)
                                
                                Image("plusIcon")
                                    .resizable()
                                    .frame(width: 25 , height: 25)
                            }
                            .offset(y: -geometry.size.height / 8 / 4)
                            .onTapGesture {
                                
                                withAnimation {
                                    isShowingMoodView.toggle()
                                    //                                coordinator.openFeelingScreen()
                                    //                                coordinator.openFeelingScreen()
                                }
                            }
                            .scaleEffect(showPopUp ? CGFloat(0.9) : 1.0)
                            .animation(Animation.spring(response: 0.35, dampingFraction: 0.35, blendDuration: 1), value: showPopUp)
                            .shadow(color: Colors.Primary.lavender500Purple.opacity(0.5), radius: 5, x: 0, y: 9)
                            
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .report, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "reportIconNoneFill", tabName: "report", filledIconName: "reportIconFill")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width / 5, height: geometry.size.height / 28, iconName: "userIconNoneFill", tabName: "profile", filledIconName: "userIconFill")
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height / 12)
                    }
                    .background(Color.white.clipShape(CustomShape()))
                    .frame(width: geometry.size.width, height: isHiddenTabBar ? 0 : geometry.size.height / 10)
                    .shadow(color: Colors.TextColors.mischka500.opacity(0.7), radius: 7, x: 0, y: -5)
                    .opacity(isHiddenTabBar ? 0 : 1)
                }
                .background(.clear)
                .edgesIgnoringSafeArea(.bottom)
            }
            .sheet(isPresented: $isShowingMoodView) {
                print("dissmiss")
            } content: {
                coordinator.openFeelingScreen()
                    .interactiveDismissDisabled(true)
            }
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
