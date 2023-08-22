//
//  AttachmentView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 12.01.2023.
//

import UIKit
import SwiftUI
import AVFoundation

struct AttachmentView: View {
    
    @State var attachments: [Image] = []

    @State private var showingGalleryPicker: Bool = false
    @State private var showingCameraPicker: Bool = false
    @State var showAlert: Bool = false
    
    @State private var inputImage: UIImage?
    @State private var inputImageURL: URL?
    
    @State private var image: Image?
    
//    @State var viewModel: ConsultantView.ViewModel
    
    @State private var modelName = UIDevice.modelName

    private let flexibleLayout = Array(repeating: GridItem(.fixed(110)), count: 3)

    var body: some View {
        LazyVGrid(columns: flexibleLayout) {
            if attachments.isEmpty && attachments.count < 6 {
                createEmptyImage()
            } else {
                ForEach(0..<attachments.count, id: \.self) { item in
                    ZStack {
                        attachments[item]
                            .resizable()
                            .frame(maxWidth: modelName == "iPhone 7" || modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 11" || modelName == "iPhone 12" || modelName == "iPhone 13" || modelName == "iPhone 15" ? 90 : 110, maxHeight: modelName == "iPhone 7" || modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 11" || modelName == "iPhone 12" || modelName == "iPhone 13" || modelName == "iPhone 15" ? 90 : 110, alignment: .leading)
                            .cornerRadius(10)
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.horizontal, 7)
                            .onTapGesture {
//                                showAlerView()
                                if attachments.count < 6 {
                                    showAlert.toggle()
                                }
                            }
                        
                        Button(action: { deletePhoto(index: item) }) {
                            Image("crossIconWhite")
                                .frame(width: 32, height: 32)
                                .background(
                                    Rectangle()
                                        .foregroundColor(Color.black.opacity(0.5))
                                        .cornerRadius(32 / 2)
                                )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.top, modelName == "iPhone 7" || modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 11" || modelName == "iPhone 12" || modelName == "iPhone 13" || modelName == "iPhone 15" ? 12 : 8)
                        .padding(.trailing, 16)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .transition(.opacity)
                }
                
                if attachments.count < 6 {
                    withAnimation {
                        createEmptyImage()
                    }
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: .infinity, alignment: .leading)
        .padding(.top, 16)
        .sheet(isPresented: $showingGalleryPicker) {
            GalleryPhotoPicker(image: $inputImage) { didSelectItems in
                print(didSelectItems)
            }
        }
        .fullScreenCover(isPresented: $showingCameraPicker) {
            ImagePicker(sourceType: .camera, selectedImage: $inputImage)
                .ignoresSafeArea(.all)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .actionSheet(isPresented: $showAlert) {
            ActionSheet(
                title: Text(""),
                buttons: [
                    .default(
                        Text("Выбрать из галереи. Доступно: \(6 - attachments.count)")) {
                        showingGalleryPicker = true
                    },
                    
                    .default(Text("Сделать фотографию")) {
                        self.checkAccessToCamera { result in
                            if result {
                                showingCameraPicker = true
                            } else {
                                #warning("TODO: Показать что доступов нет")
        //                        viewModel.showGalleryAccessPopup()
                            }
                        }
                    },
                
                    .cancel(Text("Отмена")) {
                        showAlert.toggle()
                    }
                ]
            )
        }
    }
    
    @ViewBuilder
    func createEmptyImage() -> some View {
        Image("attachmentsEmptyIcon")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: modelName == "iPhone 7" || modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 11" || modelName == "iPhone 12" || modelName == "iPhone 13" || modelName == "iPhone 15" ? 90 : 110, maxHeight: modelName == "iPhone 7" || modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 11" || modelName == "iPhone 12" || modelName == "iPhone 13" || modelName == "iPhone 15" ? 90 : 110, alignment: .leading)
            .padding(.horizontal, 7)
            .cornerRadius(10)
            .onTapGesture {
//                showAlerView()
                if attachments.count < 6 {
                    showAlert.toggle()
                }
            }
//            .skeleton(with: viewModel.userInfoModel == nil, size: CGSize(width: 130, height: 130))
//            .shape(type: .rectangle)
//            .cornerRadius(7)
    }
    
    private func checkAccessToCamera(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granded in
            return completion(granded)
        }
    }
    
    func deletePhoto(index: Int) {
        attachments.remove(at: index)
//        viewModel.removePhoto(index: index)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
                
//        viewModel.attachments.append(inputImage)
        
        withAnimation {
            attachments.append(image!)
        }
    }
}
