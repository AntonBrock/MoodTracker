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
    @Binding var model: JournalViewModel?
    
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
                .background(GradientRoundedCornersView(gradient: [Color(hex: "FFD7B1"),
                                                                  Color(hex: "FEF7F1")],
                                                       tl: 0, tr: 0, bl: 10, br: 10))
            
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Активность")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.leading, 16)
                    
                    ScrollView(.horizontal,
                               showsIndicators: false) {
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
                    }
                    .frame(height: 68)
                    .padding(.horizontal, 16)
                }
                .background(.white)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Чувства")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.leading, 16)

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
                            }
                        }
                        .frame(height: 150)
                    }
                    .padding(.leading, 16)
                }
                .background(.white)

                HStack {
                    Text("Уровень стресса")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.leading, 16)

                    Spacer()
                    
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 16, height: 16)
                            
                            Circle()
                                .fill(Colors.Primary.lavender500Purple)
                                .frame(width: 12, height: 12)
                        }
                        
                        Text("Средний стресс")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Colors.Primary.blue)
                    }
                    .padding(.trailing, 16)
                }
                .background(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Твои мысли")
                        .foregroundColor(Colors.Primary.blue)
                        .font(.system(size: 16, weight: .semibold))

                    VStack {
                        Text("Дневник благодарности - практика, позволяющая вам бла бла бла бла бла бла бла бла бла бла блаб блаблабла блаб балб аблаб бал ")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.top, 11)
                }
                .background(.white)
                .padding(.top, 10)
                .padding(.bottom, 240)
                .padding(.leading, 16)
            }
            .padding(.top, 24)
        }
        .matchedGeometryEffect(id: model?.id, in: animation)
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
                Image("ch-ic-good")
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
