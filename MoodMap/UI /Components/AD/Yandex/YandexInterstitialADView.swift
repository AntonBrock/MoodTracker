//
//  YandexInterstitialADView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 10.04.2023.
//

import SwiftUI

struct YandexInterstitialADView: UIViewControllerRepresentable {
    typealias UIViewControllerType = YandexInterstitialADViewController
    
    var willDisappear: (() -> Void)
    var showADASScreen: (() -> Void)

    func makeUIViewController(context: Context) -> YandexInterstitialADViewController {
        let vc = YandexInterstitialADViewController {
            self.willDisappear()
        } showADASScreen: {
            self.showADASScreen()
        }
        vc.loadInterstitial()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: YandexInterstitialADViewController, context: Context) {}
}
