//
//  GalleryPhotoPicker.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 12.01.2023.
//

import PhotosUI
import SwiftUI

struct GalleryPhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    var didFinishPicking: (_ didSelectItems: Bool) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 6
        config.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: config)
        
        picker.delegate = context.coordinator
        
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        
        let parent: GalleryPhotoPicker

        init(_ parent: GalleryPhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.didFinishPicking(!results.isEmpty)
            
            guard !results.isEmpty else {
                picker.dismiss(animated: true)
                return
            }
            
            for result in results {
                let itemProvider = result.itemProvider
                
                self.getPhoto(from: itemProvider, isLivePhoto: false)
                picker.dismiss(animated: true)
            }
        }
        
        private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool) {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.image = image
                        }
                    }
                }
            }
        }
    }
}
