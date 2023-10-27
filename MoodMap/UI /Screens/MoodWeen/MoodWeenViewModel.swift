//
//  MoodWeenModel.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.10.2023.
//

import SwiftUI

extension MoodWeenView {
    class ViewModel: ObservableObject {
        
        @Published var viewer: MoodWeenView?
        
        @Published var articles: [ArticlesViewModel] = []
        @Published var header: HeaderData?
    
        func setupViewer(_ viewer: MoodWeenView) {
            self.viewer = viewer
            
            self.articles = [
                ArticlesViewModel(
                    backroundImage: "ic-testArt-firstPage_whatIsMoodween",
                    text: "Добро пожаловать в первое событие приложения, которое посвящено Halloween!"
                 ),
                ArticlesViewModel(
                    backroundImage: "ic-testArt-secondPage_whatIsMoodween",
                    text: "Мы, как команда разработчиков хотим не просто дать отличное приложение, которые будет помогать отслеживать твое состояние, а также выполнять практики и следить за статистикой – \n\nнашей целью является также сделать его интересным и гибким.\nПриложение, которое будет реагировать на внешние и внутренние события. "
                ),
                ArticlesViewModel(
                    backroundImage: "ic-testArt-thirdPage_whatIsMoodween",
                    text: "Мы очень хотим привнести новый дизайн, эффекты, активности, некоторые мини-игры в момент событий. А еще мы знаем, что праздники могут повлиять на твое состояние, стресс или эмоции, которые ты испытываешь – именно поэтому мы планируем подстраивать наше приложение под эти праздники. Все это будет создано, чтобы у тебя была возможность вовремя и главное актуально отмечать свои чувства внутри приложения."
                ),
                ArticlesViewModel(
                    backroundImage: "ic-testArt-lastPage_whatIsMoodween",
                    text: "Надеемся, тебя как и нас это очень вдохновляет и воодушевляет! Отличного тебе MoodWeen, главное без стресса и с отличным настроением :)"
                )
            ]
            
            self.header = HeaderData(title: "Что такое\nMoodWeen", imageBacgkourd: "ic-testArt-header")
        }
    }
}
        
