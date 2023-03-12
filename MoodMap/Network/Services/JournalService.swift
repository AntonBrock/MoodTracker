//
//  JournalService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.03.2023.
//

import Foundation

protocol JournalServiceProtocol {
    func getUserNotes(completion: @escaping(Result<[JournalModel], Error>) -> Void)
    func getUserNotesWithDate(from: String,
                              to: String,
                              completion: @escaping(Result<[JournalModel], Error>) -> Void)
    func sendUserNote(activities: [String],
                      emotionId: String,
                      stateId: String,
                      stressRate: Int,
                      text: String,
                      completion: @escaping(Result<Bool, Error>) -> Void)
}

struct JournalService: JournalServiceProtocol {
    func sendUserNote(activities: [String],
                      emotionId: String,
                      stateId: String,
                      stressRate: Int,
                      text: String,
                      completion: @escaping(Result<Bool, Error>) -> Void) {
        let target = BaseAPI.journal(.sendUserNote(activities: activities,
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
    
    func getUserNotes(completion: @escaping(Result<[JournalModel], Error>) -> Void) {
        let target = BaseAPI.journal(.getUserNotes(from: nil, to: nil))

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? JSONDecoder().decode([JournalModel].self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func getUserNotesWithDate(from: String, to: String, completion: @escaping(Result<[JournalModel], Error>) -> Void) {
        
        let target = BaseAPI.journal(.getUserNotes(from: from, to: to))

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? JSONDecoder().decode([JournalModel].self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
