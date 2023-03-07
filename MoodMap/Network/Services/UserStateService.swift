//
//  UserStateService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 07.03.2023.
//

import Foundation

protocol UserStateServiceProtocol {
    func getEmotionList(completion: @escaping(Result<Bool, Error>) -> Void)
    func getActivitiesList(completion: @escaping(Result<Bool, Error>) -> Void)
}

struct UserStateService: UserStateServiceProtocol {
    func getEmotionList(completion: @escaping(Result<Bool, Error>) -> Void) {
        let target = BaseAPI.userState(.getEmotionsList)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                print(result)
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func getActivitiesList(completion: @escaping(Result<Bool, Error>) -> Void) {
        let target = BaseAPI.userState(.getActivitiesList)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                print(result)
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
