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

    func loadInterstitial() {
        self.interstitialAd = YMAInterstitialAd(adUnitID: "demo-interstitial-yandex") // - 2313494 изменить на проде
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
        presentInterstitial()
        print("Ad loaded")
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
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print("Interstitial ad will present screen")
    }
}
