//
//  AuthService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func singUp(with model: UserInfoModel, completion: @escaping(Result<Bool, Error>) -> Void)
}

struct AuthService: AuthServiceProtocol {
    
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
    
    func singUp(with model: UserInfoModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = BaseAPI.auth(.singUp(with: model))
        
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    //                    let models = try decoder.decode(UserInfoModel.self, from: result.data)
                    
//                    completion(.success(models))
                    print(result)
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
