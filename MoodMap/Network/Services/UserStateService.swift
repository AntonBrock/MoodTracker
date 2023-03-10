//
//  UserStateService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import Foundation

protocol UserStateServiceProtocol {
    func getStateList(completion: @escaping(Result<[StatesModel], Error>) -> Void)
    func getEmotionList(completion: @escaping(Result<[EmotionsModel], Error>) -> Void)
    func getActivitiesList(completion: @escaping(Result<[ActivitiesModel], Error>) -> Void)
}

struct UserStateService: UserStateServiceProtocol {
    func getStateList(completion: @escaping(Result<[StatesModel], Error>) -> Void) {
        let target = BaseAPI.userState(.getStateList)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? JSONDecoder().decode([StatesModel].self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func getEmotionList(completion: @escaping(Result<[EmotionsModel], Error>) -> Void) {
        let target = BaseAPI.userState(.getEmotionsList)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                let decoder = JSONDecoder()
                guard let model = try? decoder.decode([EmotionsModel].self,
                                                      from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func getActivitiesList(completion: @escaping(Result<[ActivitiesModel], Error>) -> Void) {
        let target = BaseAPI.userState(.getActivitiesList)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? JSONDecoder().decode([ActivitiesModel].self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func sendUserNote(activities: [String],
                      emotionId: String,
                      stateId: String,
                      stressRate: Int,
                      text: String,
                      completion: @escaping(Result<Bool, Error>) -> Void) {
        let target = BaseAPI.userState(.sendUserNote(activities: activities,
                                                     emotionId: emotionId,
                                                     stateId: stateId,
                                                     stressRate: stressRate,
                                                     text: text))

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success:
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
