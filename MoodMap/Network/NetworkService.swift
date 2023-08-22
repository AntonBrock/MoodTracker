//
//  NetworkService.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation
import Moya

final class NetworkService: BaseService {
    
    fileprivate let netProvider: MoyaProvider<MultiTarget> = {
        let authPlugin = AccessTokenPlugin(tokenClosure: { (type) -> String in
            switch type {
            case .bearer:
                return AppState.shared.jwtToken ?? ""
            default:
                return ""
            }
        })
        
        return MoyaProvider<MultiTarget>(
            endpointClosure: MoyaProvider<MultiTarget>.defaultEndpointMapping,
            requestClosure: MoyaProvider<MultiTarget>.defaultRequestMapping,
            stubClosure: MoyaProvider<MultiTarget>.neverStub,
            callbackQueue: nil,
            session: MoyaProvider<MultiTarget>.defaultAlamofireSession(),
            plugins: [authPlugin],
            trackInflights: false
        )
    }()
    
    func request(
        _ target: MultiTarget,
        callbackQueue: DispatchQueue? = nil,
        completion: @escaping (Result<Response, Error>) -> Void
    ) {
        netProvider.request(target, callbackQueue: callbackQueue, progress: nil) { (result) in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 404:
                    completion(.failure(MMError.defined(.pageNotFound)))
                case 401:
                    completion(.failure(MMError.defined(.tokenUndefined)))
                case 400, 403, 424, 500:
                    var error: Error
                    if let json = try? response.mapJSON() as? [String: Any] {
                        if let message = json["message"] as? String {
                            error = MMError(message: message)
                        } else if let message = json["error"] as? String {
                            error = MMError(message: message)
                        } else if let message = json["code"] as? String {
                            error = MMError(message: message)
                        } else {
                            error = MMError.undefined
                        }
                    } else {
                        error = MMError.undefined
                    }
                    completion(.failure(error))
                case 429:
                    completion(.failure(MMError.undefined))
                case 502:
                    completion(.failure(MMError.defined(.internalDatabaseError)))
                default:
                    completion(.success(response))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
