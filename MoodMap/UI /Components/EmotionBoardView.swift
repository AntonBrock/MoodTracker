//
//  EmotionBoardView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 17.10.2022.
//

import SwiftUI

// MARK: - ActivitiesViewModel
struct ActivitiesViewModel: Identifiable {
    
    let id = UUID()
    let name: String
}

// MARK: - EmotionBoardViewModel
struct EmotionBoardViewModel: Identifiable, Equatable {
    static func == (lhs: EmotionBoardViewModel, rhs: EmotionBoardViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    
    let data: String
    let emotionTitle: String
    let activities: [ActivitiesViewModel]
    
    let color: Color
    let emotionImage: String
}

struct EmotionBoardView: View {
    
    var emotionBoardViewModels: [EmotionBoardViewModel] = [
        EmotionBoardViewModel(id: 0, data: "16:20", emotionTitle: "Sad", activities: [ActivitiesViewModel(name: "travel")], color: .green, emotionImage: "character_veryGood"),
        EmotionBoardViewModel(id: 1, data: "11:20", emotionTitle: "Happy", activities: [ActivitiesViewModel(name: "walk"), ActivitiesViewModel(name: "dance")], color: .yellow, emotionImage: "character_normal"),
        EmotionBoardViewModel(id: 2, data: "12:20", emotionTitle: "Normal", activities: [ActivitiesViewModel(name: "music")], color: .red, emotionImage: "сharacter_good")
    ]
    
    var wasTouched: ((_ id: Int) -> Void)
    var animation: Namespace.ID
    
    @State var isNeededLast: Bool = false
    @State var isHidden: Bool = false
    
    var body: some View {
        
        if emotionBoardViewModels.isEmpty {
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
                        
                        #warning("TODO: Будет в слудующей версии")
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
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.leading, 16)

                    if !isNeededLast {
                        if !isHidden {
                            VStack {
                                ForEach (0..<emotionBoardViewModels.count, id: \.self) { i in
                                    EmotionBoardDataView(activities: emotionBoardViewModels[i].activities, data: emotionBoardViewModels[i].data, emotionTitle: emotionBoardViewModels[i].emotionTitle, emotionImage: emotionBoardViewModels[i].emotionImage, color: emotionBoardViewModels[i].color, animation: animation)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                        .matchedGeometryEffect(id: emotionBoardViewModels[i].id, in: animation)
                                        .onTapGesture {
                                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                                wasTouched(emotionBoardViewModels[i].id)
                                            }
                                        }
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)).animation(.linear).combined(with: .opacity))
                        } else {
                            EmotionBoardDataView(activities: emotionBoardViewModels[0].activities, data: emotionBoardViewModels[0].data, emotionTitle: emotionBoardViewModels[0].emotionTitle, emotionImage: emotionBoardViewModels[0].emotionImage, color: emotionBoardViewModels[0].color, animation: animation)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                .onTapGesture {
                                    withAnimation {
                                        wasTouched(emotionBoardViewModels[0].id)
                                    }
                                }
                        }
                    } else {
                        EmotionBoardDataView(activities: emotionBoardViewModels[0].activities, data: emotionBoardViewModels[0].data, emotionTitle: emotionBoardViewModels[0].emotionTitle, emotionImage: emotionBoardViewModels[0].emotionImage, color: emotionBoardViewModels[0].color, animation: animation)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                            .onTapGesture {
                                withAnimation {
                                    wasTouched(emotionBoardViewModels[0].id)
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
    var color: Color
    
    var animation: Namespace.ID
    
    init(activities: [ActivitiesViewModel], data: String, emotionTitle: String, emotionImage: String, color: Color, animation: Namespace.ID) {
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
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(Colors.TextColors.cadetBlue600)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                Text(emotionTitle)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text(activities[0].name)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(color)
                        .background(.clear)
                        .frame(width: 60, height: 25, alignment: .center)
                        .minimumScaleFactor(0.5)
                        .background(color.opacity(0.4))
                        .cornerRadius(7)
                    
                    if activities.count > 1 {
                        Text("+\(activities.count - 1)")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(color)
                            .background(.clear)
                            .frame(width: 60, height: 25, alignment: .center)
                            .minimumScaleFactor(0.5)
                            .background(color.opacity(0.4))
                            .cornerRadius(7)
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
                    .frame(width: 130, height: 130)
            }
            .frame(maxWidth: .infinity, maxHeight: 130, alignment: .bottomTrailing)
            .padding(.bottom, -20)
            .padding(.trailing, -20)
            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: 120.0, alignment: .leading)
        .background(color.opacity(0.2))
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
}

// MARK: - EmotionBoardEmtyView
struct EmotionBoardEmtyView: View {
    
    var body: some View {
        VStack {
            Text("Add your mood")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Colors.TextColors.cadetBlue600)
                .padding(.top, 10)
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(.white)
                .shadow(color: Colors.TextColors.mischka500, radius: 10, x: 0, y: 0)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white)
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
}
