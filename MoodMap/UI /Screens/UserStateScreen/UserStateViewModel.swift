//
//  UserStateViewModel.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import SwiftUI

extension MoodCheckView {
    class ViewModel: ObservableObject {
        
        var stateModel: [StatesModel] = []
        
        var viewer: MoodCheckView?
        
        @Published var userStateInfoModel: UserStateInfoModel?
        
        @Published var statesViewModel: [StatesViewModel] = []
        @Published var emotionsViewModel: [[EmotionsViewModel]] = []
        @Published var activitiesViewModel: [ActivitiesViewModel] = []
        @Published var stressViewModel: [StressViewModel] = []
        
        @Published var choosedTimeDate: Date?
        @Published var choosedState: String?
        @Published var choosedEmotion: String?
        @Published var choosedActivities: [String]?
        @Published var choosedStress: String?
        @Published var mindText: String?
        
        func sendUserStateInfo(view: StressCheckView) {
            self.sendUserNote(view: view)
        }
        
        func fetch(_ viewer: MoodCheckView) {
            statesViewModel = []
            emotionsViewModel = []
            activitiesViewModel = []
            stressViewModel = []
            
            self.viewer = viewer
            viewer.showLoader()
            
            let group = DispatchGroup()
            
            group.enter()
            getStatesList(group)
            
            group.enter()
            getEmotionsList(group)
            
            group.enter()
            getActiviriesList(group)
            
            group.enter()
            getStressList(group)
            
            group.notify(queue: .main) {
                viewer.hideLoader()
            }
        }
        
        private func getStatesList(_ group: DispatchGroup) {
            Services.userStateService.getStateList { result in
                switch result {
                case .success(let models):
                    self.stateModel = models
                    self.statesViewModel.append(contentsOf:
                                                    models.map({ StatesViewModel(
                                                         id: $0.id,
                                                         text: $0.text,
                                                         image: $0.image)})
                    )
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
            }
        }
        
        private func getEmotionsList(_ group: DispatchGroup) {
            Services.userStateService.getEmotionList { result in
                switch result {
                case .success(let emotionsModels):
                    var veryBadEmotions: [EmotionsViewModel] = []
                    var badEmotions: [EmotionsViewModel] = []
                    var normalEmotions: [EmotionsViewModel] = []
                    var goodEmotions: [EmotionsViewModel] = []
                    var veryGoodEmotions: [EmotionsViewModel] = []
                    
                    #warning("TODO: Рефакторинг!!")
                    for model in emotionsModels {
                        for item in self.stateModel {
                            if model.stateId == item.id && item.id == "3d07a86f-0b8a-481c-913f-88503d10c8a2" {
                                veryBadEmotions.append(EmotionsViewModel(id: model.id,
                                                                         text: model.text,
                                                                         language: model.language,
                                                                         image: model.image,
                                                                         stateId: model.stateId))
                                
                            }
                            
                            if model.stateId == item.id && item.id == "b6bdf4d7-dc62-49e4-967e-6855f72c229b" {
                                badEmotions.append(EmotionsViewModel(id: model.id,
                                                                     text: model.text,
                                                                     language: model.language,
                                                                     image: model.image,
                                                                     stateId: model.stateId))
                                
                            }
                            
                            if model.stateId == item.id && item.id == "45be90af-0404-42dd-8bbe-66d67787840f" {
                                normalEmotions.append(EmotionsViewModel(id: model.id,
                                                                        text: model.text,
                                                                        language: model.language,
                                                                        image: model.image,
                                                                        stateId: model.stateId))
                            }
                            
                            if model.stateId == item.id && item.id == "cb79441e-23ef-4e4c-be08-c8ba293d700d" {
                                goodEmotions.append(EmotionsViewModel(id: model.id,
                                                                      text: model.text,
                                                                      language: model.language,
                                                                      image: model.image,
                                                                      stateId: model.stateId))
                                
                            }
                            
                            if model.stateId == item.id && item.id == "85306de6-18d4-4b9f-aef4-cb41ffe31619" {
                                veryGoodEmotions.append(EmotionsViewModel(id: model.id,
                                                                          text: model.text,
                                                                          language: model.language,
                                                                          image: model.image,
                                                                          stateId: model.stateId))
                            }
                        }
                    }
                    
                    self.emotionsViewModel.append(veryBadEmotions)
                    self.emotionsViewModel.append(badEmotions)
                    self.emotionsViewModel.append(normalEmotions)
                    self.emotionsViewModel.append(goodEmotions)
                    self.emotionsViewModel.append(veryGoodEmotions)
                    
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
            }
        }
        
        private func getActiviriesList(_ group: DispatchGroup) {
            Services.userStateService.getActivitiesList { result in
                switch result {
                case .success(let models):
                    self.activitiesViewModel = models.map({ ActivitiesViewModel(id: $0.id,
                                                                                text: $0.text,
                                                                                language: $0.language,
                                                                                image: $0.image)})
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
            }
        }
        
        private func getStressList(_ group: DispatchGroup) {
            Services.userStateService.getStressList { result in
                switch result {
                case .success(let models):
                    self.stressViewModel.append(contentsOf: models.compactMap({ StressViewModel(
                        id: $0.id,
                        text: $0.text,
                        image: $0.image
                    )}))
                    
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
            }
        }
        
        private func sendUserNote(view: StressCheckView) {
            
            view.showLoader()
            
            guard let stateId = choosedState else { return }
            guard let emotionId = choosedEmotion else { return }
            guard let activities = choosedActivities else { return }
            guard let stressNumber = choosedStress else { return }

            Services.journalService.sendUserNote(activities: activities,
                                                   emotionId: emotionId,
                                                   stateId: stateId,
                                                   stressRate: stressNumber,
                                                   text: mindText ?? "") { result in
                switch result {
                case .success:
                    view.showAD()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
