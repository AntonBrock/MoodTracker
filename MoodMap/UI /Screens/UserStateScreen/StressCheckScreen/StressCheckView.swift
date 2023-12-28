//
//  StressCheckView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 24.02.2023.
//

import SwiftUI
import BottomSheet

struct StressCheckView: View {
        
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var valueModel: SliderStressValueModele
    @ObservedObject var userStateVideModel: MoodCheckView.ViewModel
    
    let notificationCenter = NotificationCenter.default
    @State var color: Color = .black
    
    @FocusState private var isFocused: Bool
    @State var disabledBackButton: Bool = false
    
    var parent: BaseViewCoordinator
    var stressViewModel: [StressViewModel]

    @State var yandexInterstitialADView: YandexInterstitialADView?
    @State var text: String = ""
    @FocusState private var focusField: Bool
    
    var saveButtonDidTap: ((_ text: String, _ choosedStress: String, _ view: StressCheckView) -> Void)
    
    @State var choosedStress: String = ""
    @State var isNeedShowAD: Bool = false
    @State var isNeedShowADAsPage: Bool = false
    @State var isShowLoader: Bool = false
    
    @State var bottomSheetPosition: BottomSheetPosition = .relative(0.125)
    
    private let images: [String] = ["emoji_cool", "emoji_sad", "emoji_happy"]
    
    @State private var selectedViewIndex = 1
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            contentView()
                .onAppear {
                    choosedStress = "8b02d308-37fa-41de-bdd2-00303b976031"
                    color = colorScheme == .dark ? Colors.Primary.moodDarkBackground : .white
                }
                .bottomSheet(
                    bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [
                    .relativeBottom(0.125),
                    .relative(0.125),
                    .relativeTop(0.975)
                ], headerContent: {
                    VStack {
                        Text("Нажми, чтобы записать свои мысли")
                            .foregroundColor(colorScheme == .dark ? Colors.Primary.lightGray : Colors.Primary.blue)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            TextEditor(text: $text)
                                .foregroundStyle(colorScheme == .dark ? .white : Colors.Primary.blue)
                                .focused($focusField)
                                .multilineTextAlignment(.leading)
                                .lineLimit(35)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Готово") {
                                            self.focusField = false
                                            self.bottomSheetPosition = .relative(0.125)
                                        }
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: focusField ? .infinity : 15, alignment: .leading)
                        .padding(.horizontal, -5)
                                        
                        MTButton(buttonStyle: .fill, title: "Сохранить запись", handle: {
                            
                            switch selectedViewIndex {
                            case 0: choosedStress = "fd3f28e0-273b-4a18-8aa8-56e85c9943c0"
                            case 1: choosedStress = "8b02d308-37fa-41de-bdd2-00303b976031"
                            case 2: choosedStress = "42148e04-8ba7-468d-8ce6-4f25987bdbdf"
                            default:
                                choosedStress = "8b02d308-37fa-41de-bdd2-00303b976031"
                            }
                            
                            saveButtonDidTap(text, choosedStress, self)
                            print(selectedViewIndex)
                            
                        })
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 5)
                    .padding([.horizontal, .bottom])
                    .onTapGesture {
                        self.bottomSheetPosition = .relativeTop(0.975)
                        self.focusField = true
                    }
                    .opacity(isShowLoader ? 0 : 1)
                    .transition(.opacity)
                })
                {}
                .enableAppleScrollBehavior(false)
                .enableBackgroundBlur()
                .backgroundBlurMaterial(bottomSheetPosition == .relative(0.125) ? colorScheme == .dark ? .systemDark : .systemLight : bottomSheetPosition == .relativeBottom(0.125) ? colorScheme == .dark ? .systemDark : .systemLight : .dark(.thin))
                .customBackground(
                    color
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                        .shadow(color: .white, radius: 0, x: 0, y: 0)
                )
                .enableSwipeToDismiss(false)
                .onChange(of: bottomSheetPosition) { newValue in
                    if newValue == .relative(0.125) {
                        self.focusField = false
                    } else if newValue == .relativeTop(0.975) {
                        self.focusField = true
                    }
                }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack {
            HStack {
                Image(colorScheme == .dark ? "ic-navbar-backIcon-white" : "leftBackBlackArror")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.leading, 18)
                    .disabled(disabledBackButton)
                    .opacity(disabledBackButton ? 0.5 : 1)
                    .onTapGesture {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                Text("Укажи уровень стресса")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .white : Colors.Primary.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.leading, -42)
            }
            .frame(width: UIScreen.main.bounds.width, height: 48, alignment: .center)
            
            if isShowLoader && !isNeedShowAD {
                LoaderLottieView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if isNeedShowAD {
                ZStack {
                    LoaderLottieView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    yandexInterstitialADView
                }
            } else {
                navigationView()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $isNeedShowADAsPage) {
            yandexInterstitialADView
        }
    }
    
    @ViewBuilder
    private func navigationView() -> some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0..<3) { index in
                        VStack {
                            createStressView(index)
                                .frame(maxWidth: 300, maxHeight: .infinity, alignment: .top)
                        }
                        .frame(maxWidth: 300, maxHeight: .infinity, alignment: .top)
                        .background(
                            Image(index == 0 ? "ic-mc-lowStressBackground" : index == 1 ? "ic-mc-mediumStressBackground" : index == 2 ? "ic-mc-hightStressBackground" : "")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        )
                        .cornerRadius (25)
                        .opacity (selectedViewIndex == index ? 1.0 : 0.5)
                        .scaleEffect(selectedViewIndex == index ? 1.2 : 0.8)
                        .offset(x: CGFloat(index - selectedViewIndex) * 300 + dragOffset, y: 100)
                        .shadow(color: colorScheme == .dark ? Colors.Primary.moodDarkBackground : Colors.TextColors.mischka500, radius: 15, x: 0, y: 0)
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded({ value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    selectedViewIndex = max(0, selectedViewIndex - 1)
                                    
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    selectedViewIndex = min(images.count - 1,
                                                            selectedViewIndex + 1)
                                }
                            }
                        })
                )
            }
        }
    }
    
    func showLoader() {
        disabledBackButton.toggle()
        withAnimation {
            self.isShowLoader = true
        }
    }
    
    func hideLoader() {
        withAnimation {
            self.isShowLoader = false
        }
    }
    
    func showAD(withModel: JournalModel) {
        yandexInterstitialADView = YandexInterstitialADView(willDisappear: {
            hideAD(model: withModel)
        }, showADASScreen: {
            isNeedShowADAsPage = true
        }, hideADScreen: {
            hideAD(model: withModel)
        })
        isNeedShowAD = true
    }
    
    func hideAD(model: JournalModel) {
        notificationCenter.post(name: Notification.Name("MainScreenNotification"), object: nil)
        notificationCenter.post(name: Notification.Name("JournalNotification"), object: nil)
        
        disabledBackButton.toggle()
        parent.isShowingMoodCheckScreen = false
        
        if !(AppState.shared.isNotNeedShowSharingScreen ?? false) {
            parent.journalCoordinator.viewModel.sharingJournalViewModel = JournalViewModel(
                id: model.id,
                state: userStateVideModel.getState(from: model.stateId) ,
                title: userStateVideModel.getTitle(with: userStateVideModel.getState(from: model.stateId)),
                activities: [],
                color: userStateVideModel.getColors(with: userStateVideModel.getState(from: model.stateId)),
                stateImage: userStateVideModel.getStateImage(from: model.stateId),
                emotionImage: "",
                stressRate: "",
                text: "",
                monthTime: "",
                month: "",
                monthCurrentTime: "",
                shortTime: "",
                longTime: "",
                isMoodWeenEvent: false
            )
            
            if var userLimits = AppState.shared.userLimits {
                userLimits += 1
                
                AppState.shared.userLimits = userLimits
            }
            
            #warning("TODO: Пока скрываем функционал")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                parent.isShowingSharingScreen = true
//            }
        }
    }
    
    @ViewBuilder
    private func createStressView(_ index: Int) -> some View {
        VStack {
            HStack {
                Image(index == 0 ? "ic-mc-lowStressElement" : index == 1 ? "ic-mc-mediumStressElement" : index == 2 ? "ic-mc-hightStressElement" : "")
                    .resizable()
                    .frame(
                        width: index == 0 ? 130 : index == 1 ? 174 : index == 2 ? 200 : 0,
                        height: index == 0 ? 130 : index == 1 ? 119 : index == 2 ? 130 : 0
                    )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            HStack {
                Text(index == 0 ? "Отсутствует или низкий стресс" : index == 1 ? "Средний стресс" : index == 2 ? "Высокий стресс" : "")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
            }
            
            Text(index == 0
                 ? "Низкий стресс - это нормальная часть жизни и даже может быть полезным, так как он мотивирует к действию и повышает производительность.\n\nОн необходим для поддержания активности и бдительности в повседневных задачах"
                 : index == 1
                 ? "Средний стресс - может стать проблемой, если его игнорировать.\n\nВажно обращать внимание на физические и психологические симптомы, так как они могут привести к более серьезным проблемам со здоровьем, если не управлять ими"
                 : index == 2
                 ? "Высокий стресс - может иметь серьезные последствия для здоровья, включая болезни сердца, депрессию и другие психические расстройства.\n\nЕсли ты ощущаешь высокий стресс, важно обратиться за помощью, как к профессионалам в области здоровья, так и к близким друзьям и семье"
                 : "")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
    }
}
    
