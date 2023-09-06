//
//  StressCheckView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 24.02.2023.
//

import SwiftUI

struct StressCheckView: View {
        
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var valueModel: SliderStressValueModele
    @ObservedObject var userStateVideModel: MoodCheckView.ViewModel
    
    let notificationCenter = NotificationCenter.default
    
    @FocusState private var isFocused: Bool
    @State var disabledBackButton: Bool = false
    
    var parent: BaseViewCoordinator
    var stressViewModel: [StressViewModel]

    @State var yandexInterstitialADView: YandexInterstitialADView?
    @State var text: String = ""
    var placeholder = "У меня не выходит из головы.."
    
    var saveButtonDidTap: ((_ text: String, _ choosedStress: String, _ view: StressCheckView) -> Void)
    
    @State var choosedStress: String = ""
    @State var isNeedShowAD: Bool = false
    @State var isNeedShowADAsPage: Bool = false
    @State var isShowLoader: Bool = false
    
    private let images: [String] = ["emoji_cool", "emoji_sad", "emoji_happy"]
    
    @State private var selectedViewIndex = 1
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack {
            HStack {
                Image("leftBackBlackArror")
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
                Text("Уровень стресса")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
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
                NavigationStack {
                    VStack {
                        ZStack {
                            ForEach(0..<3) { index in
                                VStack {
                                    createStressView(index)
                                        .frame(maxWidth: 300, maxHeight: .infinity, alignment: .top)
                                }
                                .frame(maxWidth: 300, maxHeight: .infinity, alignment: .top)
                                .background(selectedViewIndex == index ? .white : Colors.Primary.blue.opacity(0.3))
                                .cornerRadius (25)
                                .opacity (selectedViewIndex == index ? 1.0 : 0.5)
                                .scaleEffect(selectedViewIndex == index ? 1.2 : 0.8)
                                .offset(x: CGFloat(index - selectedViewIndex) * 300 + dragOffset, y: 100)
                                .shadow(color: Colors.TextColors.mischka500, radius: 15, x: 0, y: 0)
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
//                StressCheckComponent(stressViewModel: stressViewModel,
//                                     valueModel: valueModel,
//                                     choosedStressID: { choosedStress in
//                    self.choosedStress = choosedStress
//                })
//                .padding(.top, 50)
//                .id(1)
                
//                VStack {
//                    ZStack {
//                        TextEditor(text: $text)
//                            .frame(maxWidth: UIScreen.main.bounds.width - 32, minHeight: 50, idealHeight: 50, maxHeight: 220, alignment: .topLeading)
//                            .font(.system(size: 16))
//                            .multilineTextAlignment(.leading)
//                            .foregroundColor(!isFocused
//                                             ? Colors.TextColors.mischka500
//                                             : Colors.Primary.blue)
//                            .colorMultiply(Colors.TextColors.porcelain200)
//                            .cornerRadius(10)
//                            .shadow(color: Colors.TextColors.cadetBlue600,
//                                    radius: 1.5,
//                                    x: 0.0,
//                                    y: 0.0
//                            )
//                            .submitLabel(.done)
//                            .focused($isFocused)
//                            .onChange(of: text) { _ in
//                                if text.last?.isNewline == .some(true) {
//                                    text.removeLast()
//                                    isFocused = false
//                                }
//                            }
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
//                .cornerRadius(10)
//                .shadow(color: Colors.TextColors.mystic400.opacity(0.3), radius: 4.0, x: 0.0, y: 0.0)
                
                MTButton(buttonStyle: .fill, title: "Сохранить", handle: {
                    if text == "У меня не выходит из головы.." {
                        text = ""
                    }
                    saveButtonDidTap(text, choosedStress, self)
                })
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $isNeedShowADAsPage) {
            yandexInterstitialADView
        }
        .onAppear {
            text = placeholder
            choosedStress = "8b02d308-37fa-41de-bdd2-00303b976031"
        }
    }
    
    func showLoader() {
        disabledBackButton.toggle()
        isShowLoader = true
    }
    
    func hideLoader() {
        isShowLoader = false
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
                longTime: ""
            )
            
            if var userLimits = AppState.shared.userLimits {
                userLimits += 1
                
                AppState.shared.userLimits = userLimits
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                parent.isShowingSharingScreen = true
            }
        }
    }
    
    @ViewBuilder
    private func createStressView(_ index: Int) -> some View {
        VStack {
            
            HStack {
                Text(index == 0 ? "Нет стресса или низкий" : index == 1 ? "Средний стресс" : index == 2 ? "Высокий стресс" : "")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
            }
            
            Text(index == 0
                 ? "Низкий стресс - это нормальная часть жизни и даже может быть полезным, так как он мотивирует к действию и повышает производительность.\n\nОн необходим для поддержания активности и бдительности в повседневных задачах"
                 : index == 1
                 ? "Средний стресс - может стать проблемой, если его игнорировать.\n\nВажно обращать внимание на физические и психологические симптомы, так как они могут привести к более серьезным проблемам со здоровьем, если не управлять ими"
                 : index == 2
                 ? "Высокий стресс - может иметь серьезные последствия для здоровья, включая болезни сердца, депрессию и другие психические расстройства.\n\nЕсли ты ощущаешь высокий стресс, важно обратиться за помощью, как к профессионалам в области здоровья, так и к близким друзьям и семье.\n\nСтрессоустойчивость и умение управлять эмоциями могут способствовать восстановлению"
                 : "")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Colors.Primary.blue.opacity(0.8))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 24)
            
            Text("Мы собираем для тебя аналитику, которая может помочь тебе понять, что вызывает тот или иной уровень стресса")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(Colors.Primary.blue.opacity(0.8))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
    }
}
    
