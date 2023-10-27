//
//  MoodWeenViewCoordinator.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.10.2023.
//

import SwiftUI

class MoodWeenViewCoordinator: ObservableObject, Identifiable {
    
    
    @ObservedObject var viewModel: MoodWeenView.ViewModel
    
    @Published var articles: Articles?
    @Published var game: MoodWeenGame?


    // MARK: - Init
    init() {
        self.viewModel = MoodWeenView.ViewModel()
    }
    
    func openArticle() {
        articles = Articles(
            articles: $viewModel.articles,
            header: $viewModel.header
        )
    }
    
    func openGame() {
        game = MoodWeenGame()
    }
}
