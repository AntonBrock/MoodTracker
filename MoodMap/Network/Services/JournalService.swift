//
//  JournalService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 11.03.2023.
//

protocol JournalServiceProtocol {
    func getUserNotes(completion: @escaping(Result<Bool, Error>) -> Void)
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
    
    func getUserNotes(completion: @escaping(Result<Bool, Error>) -> Void) {
        let target = BaseAPI.journal(.getUserNotes)

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
