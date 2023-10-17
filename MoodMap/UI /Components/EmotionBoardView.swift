//
//  EmotionBoardView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 17.10.2022.
//

import SwiftUI

struct EmotionBoardView: View {
    
    var data: [[JournalViewModel]] = []
    var wasTouched: ((_ id: String) -> Void)
    var animation: Namespace.ID
    
    @State var isNeededLast: Bool = false
    @State var isHidden: Bool = false
    
    var openMoodCheckScreenDidTap: (() -> Void)
    var showAuthViewAction: (() -> Void)
    var showLimitsView: (() -> Void)
    
    var body: some View {
        
        if data.isEmpty {
            HStack {
                EmotionBoardEmtyView()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .onTapGesture {
                        if AppState.shared.isLogin ?? false {
                            if AppState.shared.userLimits == AppState.shared.maximumValueOfLimits {
                                showLimitsView()
                            } else {
                                openMoodCheckScreenDidTap()
                            }
                        } else {
                            showAuthViewAction()
                        }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .fixedSize(horizontal: false, vertical: true)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            
            Divider()
        } else {
            EmotionsBoard()
        }
    }
    
    @ViewBuilder
    private func EmotionsBoard() -> some View {
        VStack {
            ForEach(data, id: \.self) { item in
                HStack {
                    VStack {
                        EmotionBoardDateView(
                            monthTitle: item[0].month,
                            monthDate: item[0].monthCurrentTime)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.leading, 16)

                    if !isNeededLast {
                        EmotionBoardIsNotNeededLast(item: item)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)

                Divider()
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .fixedSize(horizontal: false, vertical: true)
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    }
    
    @ViewBuilder
    private func EmotionBoardIsNotNeededLast(item: [JournalViewModel]) -> some View {
        if !isHidden {
            VStack {
                EmotionBoardIsNotNeededLastForEach(item: item)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)).animation(.linear).combined(with: .opacity))
        } else {
            EmotionBoardDataView(model: item[0], animation: animation)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .onTapGesture {
                withAnimation {
                    wasTouched(item[0].id)
                }
            }
        }
    }
    
    @ViewBuilder
    private func EmotionBoardIsNotNeededLastForEach(item: [JournalViewModel]) -> some View {
        ForEach (0..<item.count, id: \.self) { index in
            EmotionBoardDataView(model: item[index],
                                 animation: animation)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                .matchedGeometryEffect(id: item[index].id, in: animation)
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                        wasTouched(item[index].id)
                    }
                }
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
    
    var monthTitle: String
    var monthDate: String
    
    var body: some View {
        VStack {
            Text(monthTitle)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Colors.TextColors.cadetBlue600)
            Text(monthDate)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Colors.TextColors.fiord800)
        }
        .frame(maxWidth: 70, maxHeight: .infinity, alignment: .top)
        .fixedSize(horizontal: true, vertical: true)
    }
}

// MARK: - EmotionBoardDataView
struct EmotionBoardDataView: View {
    
    var model: JournalViewModel
    var animation: Namespace.ID
    
    init(model: JournalViewModel,
        animation: Namespace.ID
    ) {
        self.model = model
        self.animation = animation
    }
    
    var body: some View {
        HStack {
            ZStack {
                Image(getBackgroundNameForMoodWeenEvent(for: model.title, isMoodWeenEvent: model.isMoodWeenEvent ?? false))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, minHeight: 115.0, maxHeight: 115.0)
                
                VStack {
                    Text(model.shortTime)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                    
                    Text(model.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        ForEach(0..<model.activities.count, id: \.self) { item in
                            if item == 0 {
                                Text(model.activities[item].text)
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
                                
                                if model.activities.count > 1 {
                                    Text("+ \(model.activities.count - 1)")
                                        .font(.system(size: 12, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: true, vertical: true)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .cornerRadius(7)
                                        .background {
                                            RoundedRectangle(cornerRadius: 45, style: .circular)
                                                .fill(.white.opacity(0.3))
                                        }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
                
                Image(model.stateImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 115, height: 115)
                    .padding(.bottom, -20)
                    .clipped()
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 115.0,
                        maxHeight: 115.0,
                        alignment: .bottomTrailing
                    )
                    .mask(
                        Image(getBackgroundNameForMoodWeenEvent(for: model.title, isMoodWeenEvent: model.isMoodWeenEvent ?? false))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, minHeight: 115.0, maxHeight: 115.0)
                    )
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120.0, maxHeight: 120.0, alignment: .leading)
        .compositingGroup()
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
    
    private func getBackgroundNameForMoodWeenEvent(for title: String, isMoodWeenEvent: Bool) -> String {
        switch title {
        case "Очень хорошо": return isMoodWeenEvent ? "ic-js-moodween-background-veryGood" : "ic-js-background-veryGood"
        case "Хорошо": return isMoodWeenEvent ? "ic-js-moodween-background-good" : "ic-js-background-good"
        case "Нормально": return isMoodWeenEvent ? "ic-js-moodween-background-normal" : "ic-js-background-normal"
        case "Плохо": return isMoodWeenEvent ? "ic-js-moodween-background-bad" : "ic-js-background-bad"
        case "Очень плохо": return isMoodWeenEvent ? "ic-js-moodween-background-veryBad" : "ic-js-background-veryBad"
        default: return ""
        }
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
        .cornerRadius(15)
        .padding(.horizontal, 24)
        .shadow(color: Colors.TextColors.mystic400, radius: 10, x: 0, y: 0)
    }
}
