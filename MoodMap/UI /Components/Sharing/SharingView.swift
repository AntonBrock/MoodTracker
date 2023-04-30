//
//  SharingView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 20.04.2023.
//

import SwiftUI
import Photos

struct SharingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var notShowThisScreen: Bool = false
    
    @State var viewModel: JournalViewModel?
    @State var instagramDisable: Bool = false
    @State var showFullSuccessTitle: Bool = false
    
    @State var titleButton: String = "Сохранить изображение"
    
    var actionDismiss: (() -> Void)
    
//    если захотим поделиться вьюхой которую передали
//    var viewToShare: any View

    var body: some View {
        ZStack {
            VStack {
                sharingView()
                
                Spacer()
                
                HStack {
                    if InstagramSharingUtils.canOpenInstagramStories {
                        Button {
                            InstagramSharingUtils.shareToInstagramStories(moodView().asUIImage())
                            actionDismiss()
                        } label: {
                            HStack {
                                if instagramDisable {
                                    Text("Instagram не установлен, скачай к сеюе")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Colors.Primary.blue)
                                        .padding(.leading, 12)
                                        .padding(.trailing, 18)
                                } else {
                                    Image("ic-sh-instagram")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.leading, 18)
                                        .padding(.top, 14)
                                        .padding(.bottom, 14)
                                    
                                    Text("Поделиться в Instagram")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Colors.Primary.blue)
                                        .padding(.leading, 12)
                                        .padding(.trailing, 18)
                                }
                                
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 48)
                                    .stroke(Color(hex: "E3E5E5"), lineWidth: 1)
                            )
                        }
                        
                        Button {
                            let status = PHPhotoLibrary.authorizationStatus()
                            if status == .denied {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!)
                            } else {
                                UIImageWriteToSavedPhotosAlbum(moodView().asUIImage(), nil, nil, nil)
                                
                                withAnimation {
                                    showFullSuccessTitle.toggle()
                                }
                                
                            }
                        } label: {
                            VStack {
                                Image("ic-sh-download")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 48 / 2)
                                    .stroke(Color(hex: "E3E5E5"), lineWidth: 1)
                            )
                        }
                        .padding(.leading, 16)
                    } else {
                        Button {
                            let status = PHPhotoLibrary.authorizationStatus()
                            
                            if status == .denied {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!)
                            } else {
                                UIImageWriteToSavedPhotosAlbum(moodView().asUIImage(), nil, nil, nil)
                                titleButton = "Изображение сохранено!"
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    actionDismiss()
                                }
                            }
                        } label: {
                            HStack {
                                Image(titleButton == "Сохранить изображение" ? "ic-sh-download" : "")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding()
                                
                                Text("\(titleButton)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Colors.Primary.blue)
                                    .padding(.trailing, 18)
                                    .padding(.leading, -10)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 48 / 2)
                                    .stroke(Color(hex: "E3E5E5"), lineWidth: 1)
                            )
                        }
                        .padding(.leading, 16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                MTButton(buttonStyle: .outline, title: "Позже") {
                    dismiss.callAsFunction()
                }
                .frame(height: 48)
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                Button {
                    notShowThisScreen.toggle()
                    AppState.shared.isNotNeedShowSharingScreen = notShowThisScreen
                } label: {
                    
                    HStack {
                        Image(notShowThisScreen ? "ic-sh-checkbox-selected" : "ic-sh-checkbox-unselected")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("Больше не спрашивать")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(Colors.Primary.lavender500Purple)
                            .padding(.leading, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if showFullSuccessTitle {
                VStack {
                    Text("Изображение сохранено!")
                        .padding()
                        .background(.white)
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 16, weight: .bold))
                        .cornerRadius(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(.black.opacity(0.5))
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            self.showFullSuccessTitle = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            actionDismiss()
                        }
                    }
                }
            }
        }
        .onAppear() {
            self.notShowThisScreen = AppState.shared.isNotNeedShowSharingScreen ?? false
        }
    }
    
    @ViewBuilder
    private func sharingView() -> some View {
        VStack {
            Button {
                dismiss.callAsFunction()
            } label: {
                Image("crossIcon")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)
            .padding(.leading, 24)
            
            Text("Поделись своим\nсостоянием")
                .font(.system(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 24)
            
            moodView()
            .padding(.top, 24)
        }
    }
    
    @ViewBuilder
    private func moodView() -> some View {
        VStack {
            Text("Я чувствую себя")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 25)
            
            Text("\(viewModel?.title ?? "")")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal, 13)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                Text("MoodMap")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.leading, 21)
                    .padding(.bottom, 10)
                    
                Image("\(viewModel?.stateImage ?? "")")
                    .resizable()
                    .frame(width: 141, height: 141)
                    .padding(.trailing, -50)
                    .padding(.bottom, -50)
            }
        }
        .frame(width: 200, height: 200)
        .background(LinearGradient(colors: [viewModel?.color[0] ?? .white, viewModel?.color[1] ?? .red], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(16)
    }
}
