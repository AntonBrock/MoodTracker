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
                return ""
//                return Global.services.authorizationService.jwtToken ?? ""
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
                case 401:
//                    completion(.failure(CBError.unauthorized))
                    completion(.failure(Error.self as! Error))
                case 400, 403, 500:
                    var error: Error
                    if let json = try? response.mapJSON() as? [String: Any] {
                        if let message = json["message"] as? String {
//                            error = CBError(description: message, code: response.statusCode)
                            completion(.failure(Error.self as! Error))
                        } else if let message = json["error"] as? String {
//                            error = CBError(description: message, code: response.statusCode)
                            completion(.failure(Error.self as! Error))
                        } else if let message = json["code"] as? String {
//                            error = CBError(description: message, code: response.statusCode)
                            completion(.failure(Error.self as! Error))
                        } else {
//                            error = CBError.undefinedError
                            completion(.failure(Error.self as! Error))
                        }
                    } else {
//                        error = CBError.undefinedError
                        completion(.failure(Error.self as! Error))
                    }
                    completion(.failure(Error.self as! Error))
                case 429:
//                    completion(.failure(CBError.undefinedError))
                    completion(.failure(Error.self as! Error))
                case 502:
//                    completion(.failure(CBError.serverUnavailable))
                    completion(.failure(Error.self as! Error))
                default:
                    completion(.success(response))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
