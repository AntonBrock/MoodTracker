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
        @Published var choosedActivities: [String] = []
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
            getStatesList(group) {
                group.enter()
                self.getEmotionsList(group)
            }
            
            group.enter()
            self.getActiviriesList(group)
            
            group.enter()
            self.getStressList(group)
            
            group.notify(queue: .main) {
                self.viewer?.hideLoader()
            }
        }
        
        private func getStatesList(_ group: DispatchGroup, compeltion: @escaping () -> Void) {
            Services.userStateService.getStateList { result in
                switch result {
                case .success(let models):
                    self.stateModel = models
                    
                    for item in self.stateModel {
                        self.statesViewModel.append(StatesViewModel(id: item.id, text: item.text, image: item.image))
                    }
                  
                    compeltion()
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
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
                        for item in self.statesViewModel {
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
                    
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        }
        
        private func getActiviriesList(_ group: DispatchGroup) {
            Services.userStateService.getActivitiesList { result in
                switch result {
                case .success(let models):
                    self.activitiesViewModel = models.map(
                        { ActivitiesViewModel(
                            id: $0.id,
                            text: $0.text,
                            language: $0.language,
                            image: $0.image)
                        })
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
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
                    
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        }
        
        private func sendUserNote(view: StressCheckView) {
            
            view.showLoader()
            
            guard let stateId = choosedState else { return }
            guard let emotionId = choosedEmotion else { return }
            guard let stressNumber = choosedStress else { return }
            
            guard let createdAt = choosedTimeDate else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Set the desired timezone
            let dateString = dateFormatter.string(from: createdAt)

            Services.journalService.sendUserNote(
                createdAt: dateString,
                activities: choosedActivities,
                emotionId: emotionId,
                stateId: stateId,
                stressRate: stressNumber,
                text: mindText ?? "") { result in
                switch result {
                case .success(let model):
                    Services.metricsService.sendEventWith(eventName: .createEmotionNoteButton)
                    Services.metricsService.sendEventWith(eventType: .createEmotionNoteButton)

                    view.showAD(withModel: model)
                case .failure(let error):
                    withAnimation {
                        self.viewer?.coordinator.parent.showErrorScreen = true
                        self.viewer?.coordinator.parent.errorTitle = error.localizedDescription
                    }
                }
            }
        }
        
        func getTitle(with state: JournalViewModel.State) -> String {
            switch state {
            case .diary: return "Дневник благодарности"
            case .veryBad: return "Очень плохо"
            case .bad: return "Плохо"
            case .fine: return "Нормально"
            case .good: return "Хорошо"
            case .veryGood: return "Очень хорошо"
            }
        }
        
        func getState(from stringState: String) -> JournalViewModel.State {
            switch stringState {
            case "3d07a86f-0b8a-481c-913f-88503d10c8a2": return .veryBad
            case "b6bdf4d7-dc62-49e4-967e-6855f72c229b": return .bad
            case "45be90af-0404-42dd-8bbe-66d67787840f": return .fine
            case "cb79441e-23ef-4e4c-be08-c8ba293d700d": return .good
            case "85306de6-18d4-4b9f-aef4-cb41ffe31619": return .veryGood
            default: return .fine
            }
        }
        
        func getStateImage(from stringUserState: String) -> String {
            switch stringUserState {
            case "3d07a86f-0b8a-481c-913f-88503d10c8a2": return "ch-ic-veryBad"
            case "b6bdf4d7-dc62-49e4-967e-6855f72c229b": return "ch-ic-sad"
            case "45be90af-0404-42dd-8bbe-66d67787840f": return "ch-ic-fine"
            case "cb79441e-23ef-4e4c-be08-c8ba293d700d": return "ch-ic-good"
            case "85306de6-18d4-4b9f-aef4-cb41ffe31619": return "ch-ic-veryGood"
            default: return "ch-ic-fine"
            }
        }
        
        func getColors(with state: JournalViewModel.State) -> [Color] {
            switch state {
            case .diary: return [Color(hex: "86E9C5"), Color(hex: "0B98C5")]
            case .veryBad: return [Color(hex: "FFC8C8"), Color(hex: "F95555")]
            case .bad: return [Color(hex: "7392FC"), Color(hex: "7137AF")]
            case .fine: return [Color(hex: "BBBAFF"), Color(hex: "973FF4")]
            case .good: return [Color(hex: "86E9C5"), Color(hex: "11AADF")]
            case .veryGood: return [Color(hex: "FFC8C8"), Color(hex: "FFC794")]
            }
        }
    }
}
