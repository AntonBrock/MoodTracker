//
//  DiaryView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 28.12.2022.
//

import SwiftUI

struct DiaryView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image("сharacter_good")
                    .resizable()
                    .frame(width: 134, height: 134, alignment: .center)
                    
                Text("Дневник благодарности – это психологический инструмент, помогающий скорректировать самооценку, восприятие мира.\n\nТакой дневник является своеобразным приемником, помогающим настроить жизнь на правильную позитивную волну")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.Primary.blue)
                    .font(.system(size: 16))
                    .padding(.horizontal, 38)
                
                ActivitiesTextViewBlock(subPlaceholder: "Запишите, за что испытываете чувство благодарности", type: .diary)
                    .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
            }
        }
    }
}
