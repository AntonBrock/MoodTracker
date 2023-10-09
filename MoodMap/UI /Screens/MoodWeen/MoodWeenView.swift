//
//  MoodWeenView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 04.10.2023.
//

import SwiftUI

struct MoodWeenView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    
    private var coordinator: MoodWeenViewCoordinator
    var close: (() -> Void)?
    
    @State var open: Bool = false
    @State var openGame: Bool = false
    
    init(closeDismiss: (() -> Void)? = nil){
        self.coordinator = MoodWeenViewCoordinator()
        self.viewModel = coordinator.viewModel
        self.close = closeDismiss
    }
    
    var body: some View {
        ZStack {
            Image("ic-main-banner-moodWeen")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .edgesIgnoringSafeArea(.all)
                 
            VStack {
                Image("ic-cross-white")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.top, 30)
            .padding(.leading, 30)
            
            Spacer()
            
            VStack {
             
                Text("Событие")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 16, weight: .semibold))
                
                Text("MoodWeen")
                    .foregroundColor(Color(hex: "FFA235"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 36, weight: .bold))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 65)

            Spacer()
            
            VStack(spacing: 16) {
                Spacer()
                
                HStack(spacing: 16) {
                    Image("ic-main-banner-whatIsMoodWenn")
                        .resizable()
                        .frame(width: 125, height: 125)
                        .onTapGesture {
                            open.toggle()
                        }
                    
                    Image("ic-main-banner-game")
                        .resizable()
                        .frame(width: 125, height: 125)
                        .onTapGesture {
                            openGame.toggle()
                        }
                }
                MTButton(buttonStyle: .fill, title: "Назад") {
                    dismiss.callAsFunction()
                }
                .frame(maxWidth: 227, maxHeight: 48)
                .padding(.top, 48)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $open) {
            Articles(articles: $viewModel.articles, header: $viewModel.header)
        }
        .sheet(isPresented: $openGame) {
            MoodWeenGame()
        }
        .onAppear {
            viewModel.setupViewer(self)
        }
    }
}
