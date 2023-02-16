//
//  SwiftUISlider.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 12.09.2022.
//

import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    
    class UXSlider: UISlider {
        
        var thumbView: UIView?
        
//        var dragBegan: () -> Void = {}
//        var dragEnded: () -> Void = {}
        
        override init(frame: CGRect = .zero) {
            super.init(frame: frame)
            
            self.addTarget(self, action:#selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
            if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began: return
                case .moved: return
                case .ended: return
                default:
                    break
                }
            }
        }
    }

    final class Coordinator: NSObject {
        var value: Binding<Double>
                
        init(value: Binding<Double>) {
            self.value = value
        }
        
//        @objc func beganDraging(_ sender: UISlider) {
//            print("2")
//            self.value.wrappedValue = Double(sender.value)
//        }
        
        @objc func valueChanged(_ sender: UISlider) {
            
            let roundedValue = Float(round(sender.value / 10) * 10).rounded(.toNearestOrEven)
            
            self.value.wrappedValue = Double(roundedValue)

        }
//
//        @objc func endingDraging(_ sender: UISlider) {
//            print("3")
//        }
    }

    var thumbSize: CGRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    var thumbBorderWidth: CGFloat = 5
    var thumbBorderColor: UIColor = .white
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?
    
//    var step: CGFloat?
    
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 50.0
    
    var dragBegan: () -> Void = {}
    var dragEnded: () -> Void = {}

    @Binding var value: Double
    
    func makeUIView(context: Context) -> UXSlider {
        let slider = UXSlider(frame: .zero)
        
//        slider.dragBegan = dragBegan
//        slider.dragMoved = dragMoved
//        slider.dragEnded = dragEnded
        
        customizeSlider(slider)
        
        slider.addTarget(context.coordinator,
                         action: #selector(Coordinator.valueChanged(_:)),
                         for: .valueChanged
        )
        
//        slider.addTarget(context.coordinator,
//                         action: #selector(Coordinator.beganDraging(_:)),
//                         for: .editingDidBegin)
        
        return slider
    }
    
    func customizeSlider(_ slider: UXSlider) {
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.value = Float(round(value).rounded(.toNearestOrEven))   // if stepped
        slider.maximumValue = Float(maxValue)
        
        // create slide thumb
        let thumbView = UIView()
        thumbView.alpha = 1
        thumbView.backgroundColor = thumbColor
        thumbView.layer.masksToBounds = false
        thumbView.frame = thumbSize
        thumbView.layer.cornerRadius = CGFloat(thumbSize.height / 2)
        thumbView.layer.borderWidth = thumbBorderWidth
        thumbView.layer.borderColor = thumbBorderColor.cgColor
        
        // render thumbView as image, then set it as the thumb view image
        let imageRenderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let thumbImage = imageRenderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
        
        slider.setThumbImage(thumbImage, for: .normal)
        slider.thumbView = thumbView
        
        // set drop shadow appearance
//        slider.layer.shadowColor = UIColor.black.cgColor
//        slider.layer.shadowOpacity = 0.2
//        slider.layer.shadowOffset = CGSize(width: 0, height: 3)
//        slider.layer.shadowRadius = 5
//
        slider.isContinuous = true
    }
    
    func updateUIView(_ slider: UXSlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
                        
        customizeSlider(slider)
        
        slider.addTarget(context.coordinator,
                         action: #selector(Coordinator.valueChanged(_:)),
                         for: .valueChanged
        )
        
//        slider.addTarget(context.coordinator,
//                         action: #selector(Coordinator.beganDraging(_:)),
////                         for: .touchDown)
////
//        slider.addTarget(context.coordinator,
//                         action: #selector(Coordinator.endingDraging(_:)),
//                         for: .touchUpInside)
    }
    
    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value)
    }
}
