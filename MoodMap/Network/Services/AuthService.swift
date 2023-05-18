//
//  AuthService.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func singUp(with gToken: String, completion: @escaping(Result<String, Error>) -> Void)
    func getUserInfo(completion: @escaping(Result<UserInfoModel, Error>) -> Void)
    func refreshToken(completion: @escaping((Result<Bool, Error>) -> Void))
    func logout(completion: @escaping((Result<Bool, Error>) -> Void))
    func deleteAccount(completion: @escaping((Result<Bool, Error>) -> Void)) 
    func setLanguage(completion: @escaping((Result<Bool, Error>) -> Void))
    func updateTimezone(completion: @escaping((Result<Bool, Error>) -> Void))
}

struct AuthService: AuthServiceProtocol {
    
    public var jwtToken: String = ""
    
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
    
    func singUp(with GToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let target = BaseAPI.auth(.singUp(GToken: GToken))
        
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let jsonResult = try! result.mapJSON() as? [String: Any] else { return }
                
                if let refreshToken = jsonResult["refresh_token"] as? String {
                    AppState.shared.refreshToken = refreshToken
                }
                
                if let jwtToken = jsonResult["access_token"] as? String {
                    completion(.success(jwtToken))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func singUp(appleIDToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let target = BaseAPI.auth(.singUpWithAppleId(AppleID: appleIDToken))
        
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let jsonResult = try! result.mapJSON() as? [String: Any] else { return }
                
                if let refreshToken = jsonResult["refresh_token"] as? String {
                    AppState.shared.refreshToken = refreshToken
                }
                
                if let jwtToken = jsonResult["access_token"] as? String {
                    completion(.success(jwtToken))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func getUserInfo(completion: @escaping(Result<UserInfoModel, Error>) -> Void) {
        let target = BaseAPI.auth(.getUserInfo)
        
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target), completion: { response in
            switch response {
            case let .success(result):
                guard let model = try? JSONDecoder().decode(UserInfoModel.self, from: result.data) else {
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func logout(completion: @escaping((Result<Bool, Error>) -> Void)) {
        let target = BaseAPI.auth(.logout)
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target)) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteAccount(completion: @escaping((Result<Bool, Error>) -> Void)) {
        let target = BaseAPI.auth(.deleteAccount)
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target)) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func setLanguage(completion: @escaping((Result<Bool, Error>) -> Void)) {
        let target = BaseAPI.auth(.setLanguage)
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target)) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTimezone(completion: @escaping((Result<Bool, Error>) -> Void)) {
        let target = BaseAPI.auth(.updateTimezone)
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target)) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
        
    func refreshToken(completion: @escaping((Result<Bool, Error>) -> Void)) {
        let target = BaseAPI.auth(.refreshToken)
        
        let networkService = ServiceProvider().networkService
        networkService?.request(.target(target)) { (result) in
            switch result {
            case let .success(response):
                guard let json = try? response.mapJSON() as? [String: Any] else {
                    return
                }
                #warning("TODO: Пока что не знаю что тут будет")
                if let refreshToken = json["refresh_token"] as? String,
                   let jwtToken = json["access_token"] as? String {
                    
                    AppState.shared.refreshToken = refreshToken
                    AppState.shared.jwtToken = jwtToken
                    completion(.success(true))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
