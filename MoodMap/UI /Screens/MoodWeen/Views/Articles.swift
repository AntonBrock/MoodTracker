//
//  Articles.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 06.10.2023.
//

import SwiftUI

struct Articles: View {
    
    @Environment(\.dismiss) var dismiss

    @Binding var articles: [ArticlesViewModel]
    @Binding var header: HeaderData?
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack() {
                    headerView(with: header ?? HeaderData(title: "none", imageBacgkourd: "none"))
                        .frame(maxWidth: .infinity, maxHeight: 208)
                        .ignoresSafeArea(.all)
                    
                    ForEach(articles) { article in
                        ZStack {
                            Image(article.backroundImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            Text(article.text)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                .padding(.top, 30)
                                .padding(.horizontal, 24)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(.all)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden)
            .ignoresSafeArea(.all)
            
            
            MTButton(buttonStyle: .fill, title: "Назад") {
                dismiss.callAsFunction()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 35)
            .padding(.horizontal, 24)
        }
        .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    func headerView(with data: HeaderData) -> some View {
        ZStack {
            Image(data.imageBacgkourd)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Text("Статья")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .font(.system(size: 16, weight: .medium))
                
                Text(data.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .font(.system(size: 32, weight: .semibold))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.leading, 25)
        }
    }
}

struct ArticlesViewModel: Identifiable {
    let id = UUID().uuidString
    let backroundImage: String
    let text: String
}

struct HeaderData {
    let title: String
    let imageBacgkourd: String
}
