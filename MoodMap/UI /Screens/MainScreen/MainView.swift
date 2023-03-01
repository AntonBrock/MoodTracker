//
//  MainView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 20.12.2022.
//

import SwiftUI

struct MainView: View {
    
    let container: DIContainer
    var animation: Namespace.ID
    
    private unowned let coordinator: MainViewCoordinator
    
    init(
        container: DIContainer,
        animation: Namespace.ID,
        coordinator: MainViewCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
        self.animation = animation
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if true {
                    EmotionBoardView (wasTouched: { id in
                        print("Открыть экран с журналом и открыть эмоцию с \(id)")
                    }, animation: animation, isNeededLast: true)
                }
                
                QuoteView()
                
                VStack(spacing: 16) {
                    Text("Эмоциональная поддержка")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .font(Fonts.InterBold16)
                        .foregroundColor(Colors.Primary.blue)
                        .lineSpacing(4.0)
                    
                    createEmotionalHelperScroll()
                        .onTapGesture {
                            coordinator.openDiary()
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.top, 37)
                .padding(.horizontal, 16)
                
            }
        }
    }
    
    @ViewBuilder
    private func createEmotionalHelperScroll() -> some View {
        let mockItems: [AnotherHelpsPreviewModel] = [
            AnotherHelpsPreviewModel(id: 0, title: "Дневник\nблагодарности", imagePreview: "dairyHelperCover"),
            AnotherHelpsPreviewModel(id: 1, title: "Будущее", imagePreview: "previewCover")
        ]
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(mockItems, id: \.self) { item in
                    ZStack {
                        Image("\(item.imagePreview)")
                        .resizable()
                        .frame(width: 240, height: 180)
                        .aspectRatio(1, contentMode: .fit)
                       
                        Text(item.title)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .foregroundColor(.white)
                            .font(Fonts.InterSemiBold16)
                            .lineSpacing(4.0)
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                        
                    }
                    .frame(width: 240, height: 180)
                    .cornerRadius(20)
                    .shadow(color: Colors.TextColors.mischka500, radius: 3.0, x: 1.0, y: 0)
                }
            }
        }.padding(.bottom, 48)
    }
}
