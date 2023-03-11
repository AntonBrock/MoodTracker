//
//  EmotionBoardView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 17.10.2022.
//

import SwiftUI

struct EmotionBoardView: View {
    
    var data: [JournalViewModel] = []
    var wasTouched: ((_ id: String) -> Void)
    var animation: Namespace.ID
    
    @State var isNeededLast: Bool = false
    @State var isHidden: Bool = false
    
    
    var body: some View {
        
        if data.isEmpty {
            HStack {
                EmotionBoardDateView()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.leading, 16)
                EmotionBoardEmtyView()
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .fixedSize(horizontal: false, vertical: true)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            
            Divider()
        } else {
            VStack {
                HStack {
                    VStack {
                        EmotionBoardDateView()
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.leading, 16)

                    if !isNeededLast {
                        if !isHidden {
                            VStack {
                                ForEach (0..<data.count, id: \.self) { i in
                                    EmotionBoardDataView(activities: data[i].activities,
                                                         data: data[i].time,
                                                         emotionTitle: data[i].title,
                                                         emotionImage: data[i].emotionImage,
                                                         color: data[i].color,
                                                         animation: animation)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                        .matchedGeometryEffect(id: data[i].id, in: animation)
                                        .onTapGesture {
                                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                                wasTouched(data[i].id)
                                            }
                                        }
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)).animation(.linear).combined(with: .opacity))
                        } else {
                            EmotionBoardDataView(activities: data[0].activities,
                                                 data: data[0].time,
                                                 emotionTitle: data[0].title,
                                                 emotionImage: data[0].emotionImage,
                                                 color: data[0].color,
                                                 animation: animation)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                .onTapGesture {
                                    withAnimation {
                                        wasTouched(data[0].id)
                                    }
                                }
                        }
                    } else {
                        EmotionBoardDataView(activities: data[0].activities,
                                             data: data[0].time,
                                             emotionTitle: data[0].title,
                                             emotionImage: data[0].emotionImage,
                                             color: data[0].color,
                                             animation: animation)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                            .onTapGesture {
                                withAnimation {
                                    wasTouched(data[0].id)
                                }
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .fixedSize(horizontal: false, vertical: true)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))

            Divider()
        }
    }
    
    private func hide() {
        withAnimation {
            isHidden.toggle()
        }
    }
}

// MARK: - EmotionBoardDateView
struct EmotionBoardDateView: View {
    var body: some View {
        VStack {
            Text("Jun")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Colors.TextColors.cadetBlue600)
            Text("20")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Colors.TextColors.fiord800)
        }
        .frame(maxWidth: 50.0, maxHeight: .infinity, alignment: .top)
        .fixedSize(horizontal: true, vertical: true)
    }
}

// MARK: - EmotionBoardDataView
struct EmotionBoardDataView: View {
    
    var activities: [ActivitiesViewModel] = []
    var data: String
    var emotionTitle: String
    var emotionImage: String
    var color: [Color]
    
    var animation: Namespace.ID
    
    init(
        activities: [ActivitiesViewModel],
        data: String,
        emotionTitle: String,
        emotionImage: String,
        color: [Color],
        animation: Namespace.ID
    ) {
        self.activities = activities
        self.data = data
        self.emotionTitle = emotionTitle
        self.emotionImage = emotionImage
        self.color = color
        
        self.animation = animation
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(data)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 14)
                
                Text(emotionTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    ForEach(0..<activities.count, id: \.self) { item in
                        if item == 0 {
                            Text(activities[item].text)
                                .font(.system(size: 12, weight: .medium))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: true, vertical: true)
                                .foregroundColor(.white)
                                .cornerRadius(7)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 45, style: .circular)
                                        .fill(.white.opacity(0.3))
                                }
                            
                            Text("+ \(activities.count - 1)")
                                .font(.system(size: 12, weight: .medium))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: true, vertical: true)
                                .foregroundColor(.white)
                                .cornerRadius(7)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 45, style: .circular)
                                        .fill(.white.opacity(0.3))
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
            
            HStack {
                Image(emotionImage)
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 135, height: 135)
            }
            .frame(alignment: .bottomTrailing)
            .padding(.trailing, -20)
            .padding(.top, 40)
//            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: 120.0, alignment: .leading)
        .background(LinearGradient(colors: color, startPoint: .topLeading, endPoint: .bottomTrailing))
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400,
                radius: 10, x: 0, y: 0)
    }
}

// MARK: - EmotionBoardEmtyView
struct EmotionBoardEmtyView: View {
    
    var body: some View {
        VStack {
            Text("Как ты себя чувствуешь?")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 24)
            Image("js-ev-plusIcon")
                .resizable()
                .frame(width: 48, height: 48, alignment: .center)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 120.0, alignment: .center)
        .background(Color.white)
//        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
}




//                        if emotionBoardViewModels.count > 1 {
//                            if !isNeededLast {
//                                VStack {
//                                    Image(systemName: "chevron.up")
//                                        .resizable()
//                                        .frame(width: 20, height: 10, alignment: .center)
//                                        .foregroundColor(Colors.TextColors.fiord800)
//                                        .rotationEffect(.radians(isHidden ? 2 * -.pi : .pi))
//
//                                    Divider()
//                                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
//
//                                    Image(systemName: "chevron.down")
//                                        .resizable()
//                                        .frame(width: 20, height: 10, alignment: .center)
//                                        .foregroundColor(Colors.TextColors.fiord800)
//                                        .rotationEffect(.radians(isHidden ? 2 * -.pi  : .pi))
//                                }
//                                .frame(width: 35, height: 80, alignment: .center)
//                                .background(.white)
//                                .compositingGroup()
//                                .cornerRadius(50 / 2)
//                                .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
//                                .onTapGesture { hide() }
//                                .padding(.top, 24)
//                            }
//                        }
