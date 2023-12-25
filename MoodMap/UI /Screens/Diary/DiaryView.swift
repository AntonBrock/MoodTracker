//
//  DiaryView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.12.2022.
//

import SwiftUI

struct DiaryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: ViewModel
    private unowned let coordinator: DiaryViewCoordinator
    
    @State private var presentNewDiaryPage: Bool = false
    @State private var presentDetailsPage: Bool = false

    @State private var choosedPage: DiaryViewModel?

    init(
        coordinator: DiaryViewCoordinator
    ){
        self.coordinator = coordinator
        self.viewModel = coordinator.viewModel
    }
    
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                headerView()
                    .frame(height: 240)
                
                Spacer()
                
                if viewModel.isShowLoader {
                    VStack {
                        LoaderLottieView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        emptyDiaryView()
                            .padding(.top, 10)
                            .onTapGesture {
                                Services.metricsService.sendEventWith(eventName: .createNewDairyPageButton)
                                Services.metricsService.sendEventWith(eventType: .createNewDairyPageButton)

                                self.presentNewDiaryPage = true
                            }
                        
                        ForEach(viewModel.diaryViewModel ?? [], id: \.id) { item in
                            diaryView(time: item.createdAt, diaryPage: item.message)
                                .padding(.top, 16)
                                .onTapGesture {
                                    self.choosedPage = item
                                    self.presentDetailsPage = true
                                }
                        }
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $presentDetailsPage, content: {
                DetailsDiaryPage(dismiss: {
                    self.presentDetailsPage = false
                }, diaryPage: choosedPage)
            })
            .sheet(isPresented: $presentNewDiaryPage) {
                NewDiaryPageView {
                    self.presentNewDiaryPage = false
                } saveNewDiaryPage: { newPage in
                    viewModel.sendNewDiaryPage(with: newPage)
                }
            }
            .onDisappear {
                withAnimation {
                    coordinator.parent.hideCustomTabBar = false
                }
            }
        }
        .disableSwipeBack()
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        ZStack {
            Image("dairyHelperCover")
               .resizable()
               .frame(maxWidth: .infinity, maxHeight: 240)
               .aspectRatio(1, contentMode: .fill)
               .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
               
            VStack {}
                .frame(maxWidth: .infinity, minHeight: 240)
                .background(
                    GradientRoundedCornersView(
                        gradient: [
                            Color(hex: "86E9C5"),
                            Color(hex: "0B98C5")
                        ],
                        tl: 0, tr: 0, bl: 10, br: 10).opacity(0.95))
                
            HStack {
                VStack {
                    Button {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                            dismiss()
                        }
                    } label: {
                        Image("ic-navbar-backIcon-white")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                    
                    VStack {
                        Text("Дневник\nблагодарности")
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    }
                    .padding(.bottom, 32)
                  
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
            }
        }
        
    }
    
    @ViewBuilder
    private func emptyDiaryView() -> some View {
        VStack {
            Text("Давай поблагодарим?")
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : Colors.Primary.blue)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)

            Text("За что ты хочешь сказать спасибо?")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "4BB4C1"))
                .font(.system(size: 11, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Image("ic-ds-empty")
                .resizable()
                .frame(width: 37, height: 37)
                .padding(.top, 18)
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .center)
        .background(colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white)
        .cornerRadius(20)
        .padding(.horizontal, 26)
        .shadow(
            color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Color(hex: "4BB4C1"),
            radius: 4.0, x: 1.0, y: 1.0
        )
        
    }
    
    @ViewBuilder
    private func diaryView(time: String, diaryPage: String) -> some View {
        VStack {
            Text(time)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "C9F0E2"))
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 14)
                .padding(.leading, 16)

            VStack {
                Text(diaryPage)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: 130, maxHeight: 60, alignment: .leading)
                    .lineLimit(4)
                    .padding(.bottom, 16)
                    .padding(.leading, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(LinearGradient(colors: [Color(hex: "53B6BE"), Color(hex: "479096")], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(
            color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mystic400,
            radius: 3.0, x: 1.0, y: 1.0
        )
    }
}

extension View {
    func disableSwipeBack() -> some View {
        self.background(
            DisableSwipeBackView()
        )
    }
}

struct DisableSwipeBackView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DisableSwipeBackViewController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class DisableSwipeBackViewController: UIViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let parent = parent?.parent,
           let navigationController = parent.navigationController,
           let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            navigationController.view.removeGestureRecognizer(interactivePopGestureRecognizer)
        }
    }
}
