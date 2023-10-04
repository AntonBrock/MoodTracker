//
//  YandexInterstitialADViewController.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 10.04.2023.
//

import UIKit
import YandexMobileAds

class YandexInterstitialADViewController: UIViewController {
    
    var interstitialAd: YMAInterstitialAd!
    var willDisappear: (() -> Void)
    var showADASScreen: (() -> Void)
    var hideADScreen: (() -> Void)
    
    init (
        dismissAction: @escaping (() -> Void),
        showADASScreen: @escaping (() -> Void),
        hideADScreen: @escaping (() -> Void)
    ) {
        self.willDisappear = dismissAction
        self.showADASScreen = showADASScreen
        self.hideADScreen = hideADScreen
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadInterstitial() {
        let id = Bundle.main.infoDictionary?["YandexADID"] ?? "R-M-2313494-1"
        
        self.interstitialAd = YMAInterstitialAd(adUnitID: "\(id)")
        self.interstitialAd.delegate = self
        self.interstitialAd.load()
    }
        
    func presentInterstitial() {
        self.interstitialAd.present(from: self)
    }
}

// MARK: - YMAInterstitialAdDelegate
extension YandexInterstitialADViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        showADASScreen()
        presentInterstitial()
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        print("Loading failed. Error: \(error)")
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        print("Ad clicked")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        print("Will leave application")
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        if Bundle.main.executableURL!.lastPathComponent != "MoodMapBeta" {
            if Bundle.main.infoDictionary?["YandexADID"]! == nil {
                hideADScreen()
            }
        }
        print("Failed to present interstitial. Error: \(error)")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will appear")
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did appear")
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will disappear")
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did disappear")
        willDisappear()
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print("Interstitial ad will present screen")
    }
}
