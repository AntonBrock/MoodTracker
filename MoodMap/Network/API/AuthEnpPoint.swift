//
//  AuthEnpPoint.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 01.03.2023.
//

import Foundation
import Moya

enum AuthEnpPoint: TargetType {
    
    case singUp(GToken: String)
    case singUpWithAppleId(AppleID: String)
    
    case getUserInfo
    case refreshToken
    
    var baseURL: URL {
        switch self {
        case .singUp, .refreshToken, .singUpWithAppleId:
            return URL(string: "https://api.mapmood.com/auth")!
        case .getUserInfo:
            return URL(string: "https://api.mapmood.com/v1/users")!
        }
    }
    
    var path: String {
        switch self {
        case .refreshToken: return "/token/refresh"
        case .singUp:
            return "/oauth/google"
        case .singUpWithAppleId: return "/oauth/apple"
        case .getUserInfo:
            return "/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .singUp, .singUpWithAppleId:
            return .post
        case .getUserInfo, .refreshToken:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .singUp(let GToken):
            return .requestParameters(
                parameters: ["id_token": GToken],
                encoding: JSONEncoding.default)
        case .singUpWithAppleId(let AppleIDToken):
            return .requestParameters(
                parameters: ["id_token": AppleIDToken],
                encoding: JSONEncoding.default)
        case .getUserInfo:
            return .requestPlain
        case .refreshToken:
            return .requestParameters(parameters: ["refresh_token": AppState.shared.jwtToken ?? ""],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .singUp, .singUpWithAppleId: return nil
        case .getUserInfo: return ["Authorization": "Bearer \(AppState.shared.jwtToken ?? "")"]
        case .refreshToken: return ["Authorization": "Bearer \(AppState.shared.refreshToken ?? "")" ]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .singUp, .singUpWithAppleId:
            return nil
        case .getUserInfo, .refreshToken:
            return .bearer
        }
    }
    
    var dummyPlist: String? {
        return nil
    }
}
