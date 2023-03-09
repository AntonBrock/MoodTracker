//
//  UserStateViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import SwiftUI

extension MoodCheckView {
    class ViewModel: ObservableObject {
        
        @Published var userStateInfoModel: UserStateInfoModel?
        @Published var emotionsViewModel: [[EmotionsViewModel]] = []
        
        @Published var choosedTimeDate: Date?
        @Published var choosedState: String?
        @Published var choosedEmotion: String?
        @Published var choosedActivities: [String]?
        @Published var choosedStress: String?
        @Published var mindText: String?
        
        func sendUserStateInfo() {
            print(choosedState)
            print(choosedEmotion)
            print(choosedActivities)
            print(choosedStress)
            print(mindText)
        }
        
        func getEmotionsList() {
            Services.userStateService.getEmotionList { result in
                switch result {
                case .success(let emotionsModels):
//                    var veryBadEmotion: [EmotionsViewModel] = []
          
//                        if item.image.contains(where: { $0 == "-b" }) {
//                            print(item.image)
//                        }
//                        self.emotionsViewModel.append(
//                            EmotionsViewModel(
//                                id: item.id,
//                                text: item.text,
//                                language: item.language,
//                                image: item.image
//                            )
//                        )
//                    }
                    
                    print(self.emotionsViewModel)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func getActiviriesList() {
            Services.userStateService.getActivitiesList { result in
                switch result {
                case .success(let bool):
                    print(bool)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}
