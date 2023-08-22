//
//  SegmentedControlView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 09.10.2022.
//

import SwiftUI

struct SegmentedControlView: View {
    
    enum StyleSegmentControl {
        case `default`
        case gray
    }
    
    @Namespace var animation
    
    var countOfItems: Int = 0
    var segments: [String] = []
    
    @Binding var selectedIndex: Int
    @State var currentTab: String
    
    var styleSegmentControl: StyleSegmentControl = .default
    
    var body: some View {
            
        VStack {
            HStack {
                ForEach(segments, id: \.self) { segment in
                    
                    Text("\(segment)")
                        .fontWeight(.medium)
                        .padding(.vertical, 12)
                        .frame(maxWidth: UIScreen.main.bounds.width - 32 / CGFloat(countOfItems), maxHeight: styleSegmentControl == .default ? 40 : 35, alignment: .center)
                        .background(
                            ZStack {
                                if currentTab == "\(segment)" {
                                    switch styleSegmentControl {
                                    case .default:
                                        Colors.Primary.lavender500Purple
                                            .cornerRadius(25)
                                            .matchedGeometryEffect(id: "TAB", in: animation)
                                    case .gray:
                                        Colors.TextColors.athensGray300
                                            .cornerRadius(25)
                                            .matchedGeometryEffect(id: "TAB", in: animation)
                                    }
                                }
                            }
                        )
                        .foregroundColor(textColor(for: styleSegmentControl, currentTabIsSelectedSegment: currentTab == "\(segment)"))
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                                currentTab = "\(segment)"
                                selectedIndex = segments.firstIndex(where: ({ $0 == segment })) ?? 0
                            }
                        }
                    
                    if styleSegmentControl == .gray && currentTab != "\(segment)" {
                        Divider()
                    }
                }
            }
            .frame(maxHeight: styleSegmentControl == .default ? 40 : 35, alignment: .center)
            .background(styleSegmentControl == .default ? .white : Colors.TextColors.porcelain200)
            .cornerRadius(25)
            .shadow(color: styleSegmentControl == .default ? Colors.TextColors.mischka500 : .white, radius: 8, x: 0, y: 0)

        }
    }
    
    // MARK: - Private
    private func textColor(for styleSegment: StyleSegmentControl, currentTabIsSelectedSegment: Bool) -> Color {
        switch styleSegment {
        case .default:
            if currentTabIsSelectedSegment {
                return .white
            } else {
                return Colors.TextColors.cadetBlue600
            }
        case .gray:
            if currentTabIsSelectedSegment {
                return Colors.TextColors.fiord800
            } else {
                return Colors.TextColors.cadetBlue600
            }
        }
    }

}
