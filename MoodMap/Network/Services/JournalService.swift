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
    func sendUserNote(
        activities: [String],
        emotionId: String,
        stateId: String,
        stressRate: String,
        text: String,
        completion: @escaping(Result<JournalModel, Error>) -> Void)
}

struct JournalService: JournalServiceProtocol {
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

            if let date = formatter.date(from: dateStr) {
                return date
            }

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }

            throw Error.self as! Error
        })

        return decoder
    }()
    
    func sendUserNote(activities: [String],
                      emotionId: String,
                      stateId: String,
                      stressRate: String,
                      text: String,
                      completion: @escaping(Result<JournalModel, Error>) -> Void) {
        let target = BaseAPI.journal(.sendUserNote(
            activities: activities,
            emotionId: emotionId,
            stateId: stateId,
            stressRate: stressRate,
            text: text)
        )

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { result in
            switch result {
            case let .success(response):
                guard let model = try? decoder.decode(JournalModel.self, from: response.data) else {
                    return
                }
                completion(.success(model))
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
                guard let model = try? decoder.decode([JournalModel].self, from: result.data) else {
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
                guard let model = try? decoder.decode([JournalModel].self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
