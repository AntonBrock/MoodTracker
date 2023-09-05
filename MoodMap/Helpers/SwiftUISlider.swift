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

        @objc func valueChanged(_ sender: UISlider) {
            let roundedValue = Float(round(sender.value / 10) * 10).rounded(.toNearestOrEven)
            self.value.wrappedValue = Double(roundedValue)
        }
    }

    var thumbSize: CGRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    var thumbBorderWidth: CGFloat = 5
    var thumbBorderColor: UIColor = .white
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?
        
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 50.0
    
    var dragBegan: () -> Void = {}
    var dragEnded: () -> Void = {}

    @Binding var value: Double
    
    func makeUIView(context: Context) -> UXSlider {
        let slider = UXSlider(frame: .zero)
        
        customizeSlider(slider)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }
    
    func customizeSlider(_ slider: UXSlider) {
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.value = Float(round(value).rounded(.toNearestOrEven))
        slider.maximumValue = Float(maxValue)
        
        let thumbView = UIView()
        thumbView.alpha = 1
        thumbView.backgroundColor = thumbColor
        thumbView.layer.masksToBounds = false
        thumbView.frame = thumbSize
        thumbView.layer.cornerRadius = CGFloat(thumbSize.height / 2)
        thumbView.layer.borderWidth = thumbBorderWidth
        thumbView.layer.borderColor = thumbBorderColor.cgColor
        
        let imageRenderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let thumbImage = imageRenderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
        
        slider.setThumbImage(thumbImage, for: .normal)
        slider.thumbView = thumbView
        slider.isContinuous = true
    }
    
    func updateUIView(_ slider: UXSlider, context: Context) {
        customizeSlider(slider)
        
        slider.addTarget(context.coordinator,
                         action: #selector(Coordinator.valueChanged(_:)),
                         for: .valueChanged
        )
    }
    
    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value)
    }
}
