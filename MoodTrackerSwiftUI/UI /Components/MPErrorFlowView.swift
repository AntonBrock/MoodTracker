//
//  MPErrorFlowView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.12.2022.
//

import SwiftUI

enum MPErrorFlow {
    case noInternetConnection
    case failedRequest
}

struct MPErrorFlowView: View {
    
    @State private var imageSize: CGFloat = 1.05
    @State private var imageOffsetY: CGFloat = 0
    
    var networkErrorFlow: MPErrorFlow = .noInternetConnection
    var action: (() -> Void)?
    
    var titleText: String {
        switch networkErrorFlow {
        case .noInternetConnection: return "Нет интернета"
        case .failedRequest:        return "Упс, вы нас поймали!"
        }
    }

    var subtitleText: String {
        switch networkErrorFlow {
        case .noInternetConnection:
            return "Проверьте интернет или обратитесь в службу поддержки."
        case .failedRequest:
            return "Попробуй позже, мы в данный момент кое-что меняем на сервере, не беспокойся, скоро снова будем в онлайн!"
        }
    }
    
    var body: some View {
        errorContent
            .ignoresSafeArea()
    }
    
    var errorContent: some View {
        VStack {
            VStack(spacing: 20) {
                Image("character_bad")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 306, height: 302, alignment: .center)
                    .scaleEffect(imageSize)
                    .offset(y: imageOffsetY)

                VStack(spacing: 12) {
                    Text(titleText)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 45)

                    Text(subtitleText)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 33.5)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 58)
    }
}
