//
//  MoodWeenCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.10.2023.
//

import SwiftUI

struct MoodWeenCoordinatorView: View {
    
    @ObservedObject var coordinator: MoodWeenViewCoordinator
    @ObservedObject var viewModel: MoodWeenView.ViewModel
    
    var body: some View {
        NavigationView {
            MoodWeenView()
                .navigation(item: $coordinator.articles) { _ in
                    Articles(articles: $viewModel.articles, header: $viewModel.header)
                        .navigationBarHidden(false)
                        .tint(.white)
                }
        }
    }
}
