//
//  ActivitiesView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 21.09.2022.
//

import SwiftUI

struct ActivitiesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let container: DIContainer
    private unowned let coordinator: ActivitiesViewCoodinator
    
    @State var isShowStressScreen: Bool = false
    
    init(
        container: DIContainer,
        coordinator: ActivitiesViewCoodinator
    ) {
        self.container = container
        self.coordinator = coordinator
    }
    
    private let flexibleLayout = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    private var activitiesArrayImageName: [String] =
    [
        "anguished face", "face with open mouth and cold sweat", "face with cold sweat", "disappointed but relieved face",
        "disappointed face", "dizzy face", "loudly crying face", "unamused face", "anguished face", "face with open mouth and cold sweat",
        "anguished face", "face with open mouth and cold sweat", "anguished face", "face with open mouth and cold sweat"
    ]
    
    private var activitiesArrayTitle: [String] = [
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо",
        "Лицо", "Лицо", "Лицо", "Лицо"
    ]
    
    var body: some View {
        VStack {
            
            HStack {
                Image("leftBackBlackArror")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.leading, 18)
                    .onTapGesture {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                Text("Активность")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Colors.Primary.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.leading, -42)
            }
            .frame(width: UIScreen.main.bounds.width, height: 48, alignment: .center)
            
            VStack {
                Text("Выбери свою активность, чтобы отслеживать как она влияет на тебя")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(Colors.Primary.blue)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    
                    LazyVGrid(columns: flexibleLayout) {
                        
                        ForEach(0..<activitiesArrayImageName.count) { index in
                            ZStack {
                                ActivitiesChooseViewBlock(activitieImageTitle: activitiesArrayImageName[index], activitieTitle: activitiesArrayTitle[index])
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
                    
                    //                VStack {
                    //                    LazyVGrid(columns: flexibleLayout) {
                    //
                    //                        ForEach(0..<activitiesArrayImageName.count) { index in
                    //                            ZStack {
                    //                                ActivitiesChooseViewBlock(activitieImageTitle: activitiesArrayImageName[index], activitieTitle: activitiesArrayTitle[index])
                    //                            }
                    //                        }
                    //                    }
                    //                }
                    //                .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                NavigationLink(
                    isActive: $isShowStressScreen,
                    destination: {
                        StressCheckView(valueModel: coordinator.sliderValueModele!)
                            .navigationBarHidden(true)
                    },
                    label: {}
                )
                
                MTButton(buttonStyle: .fill, title: "Продолжить", handle: {
                    isShowStressScreen.toggle()
                })
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
        }
    }
}

// MARK: - ActivitiesChooseViewBlock
struct ActivitiesChooseViewBlock: View {

    var activitieImageTitle: String
    var activitieTitle: String

    @State var isSelected: Bool = false

    var body: some View {

        VStack(spacing: 1) {
            Image("\(activitieImageTitle)")
                .resizable()
                .frame(width: 38, height: 38)
            Text("\(activitieTitle)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Colors.Primary.blue)
                .padding(.top, 10)
        }
        .frame(width: 80, height: 87)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: Colors.TextColors.mystic400, radius: 6.0, x: 0, y: 0)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ?
                        Colors.Primary.royalPurple600Purple :
                        .white, lineWidth: 1)
        }
        .padding(.top, 16)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}