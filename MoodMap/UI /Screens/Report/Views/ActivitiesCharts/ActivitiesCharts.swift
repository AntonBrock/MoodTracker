//
//  ActivitiesCharts.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.03.2023.
//

import SwiftUI

struct ActivitiesCharts: View {
    
    var body: some View {
        HStack(spacing: 7) {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Colors.Secondary.shamrock600Green)
                        .overlay {
                            Text("2")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, -35)
                        .padding(.leading, 40)
                        .zIndex(9999999)

                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image("artist_palette_icon")
                                .resizable()
                                .frame(width: 30, height: 30)

                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                        }
                }
            }.frame(width: 80, height:80)
            
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Colors.Secondary.malibu600Blue)
                        .overlay {
                            Text("10+")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, -35)
                        .padding(.leading, 40)
                        .zIndex(9999999)

                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image("artist_palette_icon")
                                .resizable()
                                .frame(width: 30, height: 30)

                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Colors.Primary.lightGray.opacity(0.5), lineWidth: 1)
                        }
                }
            }.frame(width: 80, height: 80)
        }
    }
}
