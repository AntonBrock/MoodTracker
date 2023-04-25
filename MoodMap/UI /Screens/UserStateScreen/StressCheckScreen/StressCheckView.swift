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
    
    var parent: BaseViewCoordinator
    var stressViewModel: [StressViewModel]

    @State var yandexInterstitialADView: YandexInterstitialADView?
    @State var text: String = "У меня не выходит из головы "
    
    var saveButtonDidTap: ((_ text: String, _ choosedStress: String, _ view: StressCheckView) -> Void)
    
    @State var choosedStress: String = ""
    @State var isNeedShowAD: Bool = false
    @State var isNeedShowADAsPage: Bool = false
    @State var isShowLoader: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image("leftBackBlackArror")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.leading, 18)
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
                StressCheckComponent(stressViewModel: stressViewModel,
                                     valueModel: valueModel,
                                     choosedStressID: { choosedStress in
                    self.choosedStress = choosedStress
                })
                .padding(.top, 50)
                .id(1)
                
                VStack {
                    ZStack {
                        TextEditor(text: $text)
                            .frame(maxWidth: UIScreen.main.bounds.width - 32, minHeight: 50, idealHeight: 50, maxHeight: 220, alignment: .topLeading)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(text == "У меня не выходит из головы "
                                             ? Colors.TextColors.mischka500
                                             : Colors.Primary.blue)
                            .colorMultiply(Colors.TextColors.porcelain200)
                            .cornerRadius(10)
                            .shadow(color: Colors.TextColors.cadetBlue600,
                                    radius: 1.5,
                                    x: 0.0,
                                    y: 0.0
                            )
                            .onTapGesture {
                                text = ""
                            }
                            .onChange(of: text) { newValue in
                                if newValue == "" {
                                    text = "У меня не выходит из головы "
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                .cornerRadius(10)
                .shadow(color: Colors.TextColors.mystic400.opacity(0.3), radius: 4.0, x: 0.0, y: 0.0)
                
                MTButton(buttonStyle: .fill, title: "Сохранить", handle: {
                    if text == "У меня не выходит из головы " {
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
    }
    
    func showLoader() {
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
        })
        
        isNeedShowAD = true
    }
    
    func hideAD(model: JournalModel) {
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                parent.isShowingSharingScreen = true
            }
        }
        
    }
}
    
