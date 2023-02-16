//
//  ReportCoordinatorView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 23.10.2022.
//

import SwiftUI

struct ReportCoordinatorView: View {
    
    @ObservedObject var coordinator: ReportViewCoordinator

    var body: some View {        
        NavigationView {
            ReportScreen()
                .navigationTitle("Отчет")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
