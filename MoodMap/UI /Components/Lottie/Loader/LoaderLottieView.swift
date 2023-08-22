//
//  LoaderLottieView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.04.2023.
//

import SwiftUI
import Lottie

struct LoaderLottieView: UIViewRepresentable {
    
    var name: String = "SplashScreen"
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: UIViewRepresentableContext<LoaderLottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoaderLottieView>) {
        
    }
}
