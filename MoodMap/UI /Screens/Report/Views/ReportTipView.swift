//
//  ReportTipView.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct ReportTipView: View {
    
    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(width: 290, height: 40)
            .shadow(color: Colors.Primary.lightGray.opacity(0.5), radius: 5, x: 0, y: 0)
            .overlay(
                Text("Твое общее настроение изменилось на +21% с прошлой недели")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Colors.Primary.blue)
                    .padding()
            )
            .padding(.top, 30)
    }
}
