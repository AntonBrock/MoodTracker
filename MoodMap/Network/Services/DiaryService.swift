//
//  DiaryService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 02.04.2023.
//

import Foundation

protocol DiaryServiceProtocol {
    func fetchDiary(completion: @escaping(Result<[DiaryModel], Error>) -> Void)
    func setNewDiaryPage(page: String, completion: @escaping(Result<DiaryModel, Error>) -> Void)
}

struct DiaryService: DiaryServiceProtocol {
    func fetchDiary(
        completion: @escaping(Result<[DiaryModel], Error>) -> Void
    ) {
        let target = BaseAPI.diary(.getDiary)

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? AppState.shared.decoder.decode([DiaryModel].self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func setNewDiaryPage(
        page: String,
        completion: @escaping(Result<DiaryModel, Error>) -> Void
    ) {
        let target = BaseAPI.diary(.setNewPage(page: page))

        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? AppState.shared.decoder.decode(DiaryModel.self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
