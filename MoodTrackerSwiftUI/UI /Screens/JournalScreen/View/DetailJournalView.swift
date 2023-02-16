//
//  DetailJournalView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 27.12.2022.
//

import SwiftUI

struct DetailJournalView: View {
    
    @Binding var showMoreInfo: Bool
    
    var animation: Namespace.ID
    @Binding var model: EmotionBoardViewModel
    
//    @State var scale: CGFloat = 1
    
    let column: [GridItem] = [
        GridItem(.flexible())
    ]

    let mockData: [String] = [
        "Хобби",
        "Работа",
        "Йога",
        "Хобби",
        "Работа",
        "Йога",
        "Хобби",
        "Работа",
        "Йога",
        "Хобби",
        "Работа",
        "Йога"
    ]
        
    struct FeelingDataMock {
        var image: String
        var title: String
    }
    
    let mockDataFeeling: [FeelingDataMock] = [
        FeelingDataMock(image: "emoji_happy", title: "Любовь"),
        FeelingDataMock(image: "emoji_cool", title: "Радость"),
        FeelingDataMock(image: "emoji_happy", title: "Любовь"),
        FeelingDataMock(image: "emoji_cool", title: "Радость"),
        FeelingDataMock(image: "emoji_happy", title: "Любовь"),
        FeelingDataMock(image: "emoji_cool", title: "Радость")
    ]
    
    var body: some View {
        ScrollView {
            headerView()
                .frame(height: 240)
                .background(
                    GradientRoundedCornersView(gradient: [Color(hex: "FFD7B1"), Color(hex: "FEF7F1")], tl: 0, tr: 0, bl: 10, br: 10)
                )
            VStack {
                VStack(spacing: 12) {
                    Text("ЧЕМ ВЫ ЗАНИМАЛИСЬ")
                        .frame(width: UIScreen.main.bounds.width - 32, height: 56, alignment: .bottomLeading)
                        .foregroundColor(Colors.Primary.lightGray)
                        .font(.system(size: 12))

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: column, spacing: 8) {
                            ForEach(0..<mockData.count, id: \.self) { i in
                                HStack {
                                    Text(mockData[i])
                                        .foregroundColor(Colors.Secondary.neonCarrot600Orange)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            Rectangle()
                                                .fill(Colors.Secondary.negroni400Orange)
                                                .frame(height: 32)
                                                .cornerRadius(32 / 2)
                                        )
                                }
                            }
                        }
                        .frame(height: 32)
                        .padding(.horizontal, 16)
                    }
                    .frame(height: 68)
                    .background(.white)
                }
                .background(Colors.Primary.lightWhite)
                .padding(.top, -10)

                VStack(spacing: 12) {
                    Text("ВАШИ ЧУВСТВА")
                        .frame(width: UIScreen.main.bounds.width - 32, height: 56, alignment: .bottomLeading)
                        .foregroundColor(Colors.Primary.lightGray)
                        .font(.system(size: 12))

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: column, spacing: 8) {
                            ForEach(0..<mockDataFeeling.count, id: \.self) { i in
                                VStack {
                                    Image("\(mockDataFeeling[i].image)")
                                        .resizable()
                                        .frame(width: 39, height: 38)

                                    Text("\(mockDataFeeling[i].title)")
                                        .foregroundColor(.black)
                                        .font(.system(size: 11))
                                }
                                .background(
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 80, height: 90)
                                        .cornerRadius(10)
                                        .shadow(color: Colors.TextColors.mystic400, radius: 4, x: 0, y: 0)
                                )
                                .frame(width: 80, height: 90)
                                .background(.white)
                            }
                        }
                        .frame(height: 150)
                        .padding(.horizontal, 16)
                    }
                    .background(.white)
                }
                .background(Colors.Primary.lightWhite)
                .padding(.top, -10)

                VStack(spacing: 12) {
                    Text("ВАШИ МЫСЛИ")
                        .frame(width: UIScreen.main.bounds.width - 32, height: 56, alignment: .bottomLeading)
                        .foregroundColor(Colors.Primary.lightGray)
                        .font(.system(size: 12))

                    VStack {
                        Text("Дневник благодарности - практика, позволяющая вам бла бла бла бла бла бла бла бла бла бла блаб блаблабла блаб балб аблаб бал ")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 80))], spacing: 16) {
                            ForEach(0..<mockDataFeeling.count, id: \.self) { i in
                                Image("\(mockDataFeeling[i].image)")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 24)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(.white)

                }
                .background(Colors.Primary.lightWhite)
                .padding(.top, -10)
            }
//            .gesture(DragGesture(minimumDistance: 0).onChanged(onChanged(value:)).onEnded(onEnded(value:)))
        }
        .matchedGeometryEffect(id: model.id, in: animation)
//        .scaleEffect(scale)
        .ignoresSafeArea(.all, edges: .top)
    }
    
//    func onChanged(value: DragGesture.Value) {
//
//        let scale = value.translation.height / UIScreen.main.bounds.height
//
//        withAnimation {
//            if 1 - scale > 0.7 {
//                self.scale = 1 - scale
//            }
//        }
//
//    }

//    func onEnded(value:  DragGesture.Value) {
//        withAnimation(.spring()) {
//
//            if scale < 0.9 {
//                showMoreInfo.toggle()
//            }
//
//            scale = 1
//        }
//    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            VStack {
                Button {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                        showMoreInfo.toggle()
                    }
                } label: {
                    Image("leftBackBlackArror")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("19 Июня")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Счастье")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 26)
                .frame(maxWidth: .infinity, alignment: .leading)
              
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 27)
            
            VStack {
                Image("сharacter_good")
                    .resizable()
                    .frame(width: 207, height: 207, alignment: .trailing)
                    .padding(.trailing, -26)
                    .padding(.bottom, -64)
            }
            .frame(maxHeight: .infinity)
            .clipped()
        }
    }
}
