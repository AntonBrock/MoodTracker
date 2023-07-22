//
//  QuotesService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 22.07.2023.
//

import Foundation

protocol QuotesServiceProtocol {
    func fetchQuote(language: String, completion: @escaping(Result<QuotesModel, Error>) -> Void)
}

struct QuotesService: QuotesServiceProtocol {
    func fetchQuote(
        language: String,
        completion: @escaping(Result<QuotesModel, Error>) -> Void
    ) {
        let target = BaseAPI.quotes(.getQuote(language: language))
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? AppState.shared.decoder.decode(QuotesModel.self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
